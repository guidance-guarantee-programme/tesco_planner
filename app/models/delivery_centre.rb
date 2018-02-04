class DeliveryCentre < ApplicationRecord
  has_many :users
  has_many :slots
  has_many :locations
  has_many :appointments, through: :slots

  validates :name, presence: true, uniqueness: true
  validates :reply_to, presence: true, email: true
end
