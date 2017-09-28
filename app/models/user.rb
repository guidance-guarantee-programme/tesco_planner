class User < ApplicationRecord
  ADMINISTRATOR   = 'administrator'.freeze
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  belongs_to :delivery_centre, optional: true

  delegate :location, :slots, to: :delivery_centre

  scope :active, -> { where(disabled: false) }

  def self.unassigned_booking_managers
    active
      .where(delivery_centre_id: nil)
      .order(:name)
      .select(&:booking_manager?)
  end

  def appointments
    delivery_centre
      .appointments
      .includes(slot: :room)
      .order(:created_at)
  end

  def mine?(slot)
    slot.delivery_centre_id == delivery_centre_id
  end

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end

  def administrator?
    has_permission?(ADMINISTRATOR)
  end
end
