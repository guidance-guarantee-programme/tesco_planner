class Slot < ApplicationRecord
  before_validation :infer_end_at!

  belongs_to :room
  belongs_to :delivery_centre

  scope :from_tomorrow, lambda {
    where(arel_table[:start_at].gteq(Date.tomorrow.beginning_of_day))
  }

  private

  def infer_end_at!
    return if end_at?
    return unless start_at?

    self.end_at = start_at.advance(hours: 1)
  end
end
