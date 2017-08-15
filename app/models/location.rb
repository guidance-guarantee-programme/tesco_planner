class Location < ApplicationRecord
  has_many :rooms
  has_many :slots, through: :rooms

  has_many :assignments
  has_many :users, through: :assignments
end
