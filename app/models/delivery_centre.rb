class DeliveryCentre < ApplicationRecord
  has_many :users
  has_many :locations

  validates :name, presence: true, uniqueness: true
  validates :reply_to, presence: true, email: true
end
