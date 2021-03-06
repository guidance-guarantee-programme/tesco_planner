class Appointment < ApplicationRecord # rubocop:disable ClassLength
  audited

  belongs_to :slot
  has_one :room, through: :slot
  has_many :activities, -> { order('created_at DESC') }

  before_validation :calculate_type_of_appointment

  enum status: %i[
    pending
    complete
    no_show
    incomplete
    ineligible_age
    ineligible_pension_type
    cancelled_by_customer
    cancelled_by_pension_wise
    cancelled_by_customer_sms
  ]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, email: true
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :date_of_birth, presence: true
  validates :slot, presence: true, uniqueness: true
  validates :type_of_appointment, presence: true
  validates :gdpr_consent, inclusion: { in: ['yes', 'no', ''] }
  validate :cannot_reschedule_when_cancelled

  scope :by_delivery_centre, lambda { |delivery_centre|
    includes(slot: { room: :location })
      .where(locations: { delivery_centre_id: delivery_centre.id })
  }

  scope :not_booked_today, -> { where.not(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }

  scope :with_mobile, -> { where("phone like '07%'") }

  delegate :location, to: :room
  delegate :delivery_centre, to: :location

  def customer_name
    "#{first_name} #{last_name}"
  end

  def employer_name
    return '' unless location&.employer

    location.employer.name
  end

  def tesco?
    return unless location&.employer_id

    location.employer_id.to_s == ENV['TESCO_EMPLOYER_ID']
  end

  def notify?
    return false if past? || previous_changes.none?
    return true  if previous_changes.exclude?(:status)

    previous_changes[:status] && pending?
  end

  def cancel!
    transaction do
      update!(status: :cancelled_by_customer_sms)
      slot.free!

      SmsCancellationActivity.from(self)
    end
  end

  def process!(by)
    return if processed_at?

    transaction do
      touch(:processed_at) # rubocop:disable SkipsModelValidations

      ProcessedActivity.create!(user: by, appointment: self)
    end
  end

  def handle_cancellation!
    return unless should_cancel?

    slot.free!
    yield self
  end

  def booking_managers
    delivery_centre.users.active.select(&:booking_manager?)
  end

  def cancelled?
    status.start_with?('cancelled')
  end

  def should_cancel?
    return unless status_previously_changed? && cancelled?
    return if status_previous_change.first.to_s.start_with?('cancelled')

    true
  end

  def future?
    slot.start_at.future?
  end

  def past?
    slot.start_at.past?
  end

  def self.for_redaction
    where
      .not(first_name: 'redacted')
      .where('created_at < ?', 2.years.ago.beginning_of_day)
  end

  def self.for_sms_cancellation(number)
    pending
      .order(:created_at)
      .find_by("REPLACE(phone, ' ', '') = :number", number: number)
  end

  def self.needing_reminder
    pending
      .not_booked_today
      .joins(:slot)
      .where(reminder_sent_at: nil)
      .where(slots: { start_at: Time.current..48.hours.from_now })
  end

  def self.needing_sms_reminder
    two_day_range = 48.hours.from_now.beginning_of_day..48.hours.from_now.end_of_day

    pending.not_booked_today.with_mobile.joins(:slot).where(slots: { start_at: two_day_range })
  end

  private

  def calculate_type_of_appointment
    return type_of_appointment if type_of_appointment.present?

    self.type_of_appointment = if age < 50
                                 'under-50'
                               elsif (50..54).cover?(age)
                                 '50-54'
                               else
                                 '55-plus'
                               end
  end

  def age
    return 0 unless date_of_birth

    age = Time.zone.today.year - date_of_birth.year
    age -= 1 if Time.zone.today.to_date < date_of_birth + age.years
    age
  end

  def cannot_reschedule_when_cancelled
    return unless slot_id_changed? && cancelled?

    errors.add(:slot, 'cannot be rescheduled if cancelled')
  end
end
