class User < ApplicationRecord
  ADMINISTRATOR   = 'administrator'.freeze
  BOOKING_MANAGER = 'booking_manager'.freeze
  API_USER        = 'api_user'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  belongs_to :delivery_centre, optional: true

  delegate :locations, to: :delivery_centre

  scope :active, -> { where(disabled: false) }

  def assign!(dc)
    return if dc.id == delivery_centre_id

    update!(delivery_centre: dc)
  end

  def location
    return unless delivery_centre_id?

    locations.first
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
