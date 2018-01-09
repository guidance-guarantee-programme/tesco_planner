class User < ApplicationRecord
  ADMINISTRATOR   = 'administrator'.freeze
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  has_many :assignments
  has_many :delivery_centres, through: :assignments

  delegate :location, :slots, to: :delivery_centre

  scope :active, -> { where(disabled: false) }

  def delivery_centre
    delivery_centres.first
  end

  def appointments
    delivery_centre
      .appointments
      .includes(slot: :room)
      .order(:created_at)
  end

  def assigned?
    assignment_ids.present?
  end

  def mine?(slot)
    delivery_centre_ids.include?(slot.delivery_centre_id)
  end

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end

  def administrator?
    has_permission?(ADMINISTRATOR)
  end
end
