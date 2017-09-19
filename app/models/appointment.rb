class Appointment < ApplicationRecord
  belongs_to :slot
  has_one :delivery_centre, through: :slot

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

  def booking_managers
    delivery_centre.users.active
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
