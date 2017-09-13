class Location < ApplicationRecord
  has_many :rooms
  has_many :slots, through: :rooms

  has_many :delivery_centres
  has_many :users, through: :delivery_centres

  def windowed_slots
    slots
      .from_tomorrow
      .available
      .select('start_at::date as start_date, start_at')
      .order('start_date asc, start_at asc')
      .group_by(&:start_date)
      .transform_values { |value| value.map(&:start_at).uniq }
  end
end
