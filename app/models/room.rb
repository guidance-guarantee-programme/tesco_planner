class Room < ApplicationRecord
  belongs_to :location

  has_many :slots

  validates :name, presence: true, uniqueness: { scope: :location }
end
