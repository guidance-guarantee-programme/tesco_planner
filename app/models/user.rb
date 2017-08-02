class User < ApplicationRecord
  BOOKING_MANAGER = 'booking_manager'.freeze

  include GDS::SSO::User

  serialize :permissions, Array

  has_many :assignments
  has_many :locations, through: :assignments

  def booking_manager?
    has_permission?(BOOKING_MANAGER)
  end
end
