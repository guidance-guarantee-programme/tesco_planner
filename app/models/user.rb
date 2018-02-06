class User < ApplicationRecord
  ADMINISTRATOR   = 'administrator'.freeze
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  belongs_to :delivery_centre, optional: true

  scope :active, -> { where(disabled: false) }

  def location
    return unless delivery_centre_id?

    delivery_centre.locations.first
  end

  def appointments
    Appointment.by_delivery_centre(delivery_centre)
  end

  def assigned?
    delivery_centre_id?
  end

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end

  def administrator?
    has_permission?(ADMINISTRATOR)
  end
end
