class Slot < ApplicationRecord
  audited

  before_validation :infer_end_at!

  belongs_to :room
  has_one :appointment

  scope :for_location, lambda { |location|
    includes(room: :location).where(locations: { id: location.id })
  }

  scope :from_tomorrow, lambda {
    where(arel_table[:start_at].gteq(Date.tomorrow.beginning_of_day))
  }

  scope :available, lambda {
    left_outer_joins(:appointment).where(appointments: { id: nil })
  }

  def free!
    Slot.create!(
      start_at: start_at,
      end_at: end_at,
      room: room
    )
  end

  private

  def infer_end_at!
    return if end_at?
    return unless start_at?

    self.end_at = start_at.advance(hours: 1)
  end
end
