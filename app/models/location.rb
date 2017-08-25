class Location < ApplicationRecord
  has_many :rooms
  has_many :slots, through: :rooms

  has_many :delivery_centres
  has_many :users, through: :delivery_centres
end
