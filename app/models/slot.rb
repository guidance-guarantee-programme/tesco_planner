class Slot < ApplicationRecord
  after_initialize :infer_end_at!

  belongs_to :room
  belongs_to :delivery_centre

  private

  def infer_end_at!
    return if end_at?
    return unless start_at?

    self.end_at = start_at.advance(hours: 1)
  end
end
