class Location < ApplicationRecord
  before_create :build_default_room

  has_many :rooms
  has_many :slots, through: :rooms
  has_many :appointments, through: :slots

  belongs_to :employer
  belongs_to :delivery_centre
  has_many :users, through: :delivery_centre

  validates :name, presence: true
  validates :address_line_one, presence: true
  validates :town, presence: true
  validates :county, presence: true
  validates :postcode, presence: true

  scope :active, -> { where(active: true) }

  def available_slot(start_at)
    slots.available.find_by(start_at: start_at)
  end

  def windowed_slots
    slots
      .from_tomorrow
      .available
      .select('start_at::date as start_date, start_at')
      .order('start_date asc, start_at asc')
      .group_by(&:start_date)
      .transform_values { |value| value.map(&:start_at).uniq }
  end

  def address(room = '')
    [
      room,
      address_line_one,
      address_line_two,
      address_line_three,
      town,
      county,
      postcode
    ].reject(&:blank?).join("\n")
  end

  private

  def build_default_room
    return unless rooms.empty?

    rooms.build(name: 'Colleague Area')
  end
end
