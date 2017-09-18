class User < ApplicationRecord
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  belongs_to :delivery_centre, optional: true

  delegate :location, :slots, to: :delivery_centre

  scope :active, -> { where(disabled: false) }

  def appointments
    delivery_centre
      .appointments
      .includes(slot: :room)
      .order(:created_at)
  end

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end
end
