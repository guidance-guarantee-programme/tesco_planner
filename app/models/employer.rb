class Employer < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :assignments, dependent: :destroy

  has_many :delivery_centres, through: :assignments
end
