class DeliveryCentre < ApplicationRecord
  has_many :users
  has_many :slots
  has_many :appointments, through: :slots

  belongs_to :location
end
