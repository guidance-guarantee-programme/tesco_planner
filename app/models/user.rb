class User < ApplicationRecord
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  belongs_to :delivery_centre, optional: true

  delegate :location, to: :delivery_centre

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end
end
