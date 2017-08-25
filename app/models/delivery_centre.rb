class DeliveryCentre < ApplicationRecord
  has_many :users
  has_many :slots

  belongs_to :location
end
