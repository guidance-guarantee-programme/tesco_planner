class Appointment < ApplicationRecord
  belongs_to :slot
  has_one :room, through: :slot
  has_many :activities

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
  ]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, email: true
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :date_of_birth, presence: true
  validates :slot, presence: true, uniqueness: true
  validates :type_of_appointment, presence: true

  scope :by_delivery_centre, lambda { |delivery_centre|
    includes(slot: { room: :location })
      .where(locations: { delivery_centre_id: delivery_centre.id })
  }

  delegate :location, to: :room
  delegate :delivery_centre, to: :location

  def process!(by)
    return if processed_at?

    transaction do
      touch(:processed_at) # rubocop:disable SkipsModelValidations

      ProcessedActivity.create!(user: by, appointment: self)
    end
  end

  def handle_cancellation!
    return unless status_previously_changed? && cancelled?

    slot.free!
    yield self
  end

  def booking_managers
    delivery_centre.users.active
  end

  def cancelled?
    status.start_with?('cancelled')
  end

  def future?
    slot.start_at.future?
  end

  def self.needing_reminder
    pending
      .joins(:slot)
      .where(reminder_sent_at: nil)
      .where(slots: { start_at: Time.current..48.hours.from_now })
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
end
