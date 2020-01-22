class Employer < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :assignments, dependent: :destroy

  has_many :delivery_centres, through: :assignments

  validates :name, presence: true
  validates :url, presence: true, format: { with: /\A[a-z-]+\z/ }
end
