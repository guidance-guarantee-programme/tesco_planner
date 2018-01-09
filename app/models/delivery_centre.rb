class DeliveryCentre < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments

  has_many :slots
  has_many :appointments, through: :slots

  belongs_to :location

  validates :name, presence: true, uniqueness: true
  validates :reply_to, presence: true, email: true
end
