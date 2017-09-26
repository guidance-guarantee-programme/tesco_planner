class Location < ApplicationRecord
  has_many :rooms
  has_many :slots, through: :rooms

  has_many :delivery_centres
  has_many :users, through: :delivery_centres

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

  def address
    [
      address_line_one,
      address_line_two,
      address_line_three,
      town,
      county,
      postcode
    ].reject(&:blank?).join("\n")
  end
end
