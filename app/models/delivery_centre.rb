class DeliveryCentre < ApplicationRecord
  has_many :users
  has_many :locations
  has_many :assignments
  has_many :employers, through: :assignments

  validates :name, presence: true, uniqueness: true
  validates :reply_to, presence: true, email: true

  scope :visible, -> { where(hidden: false) }
end
