class SlotDecorator < SimpleDelegator
  include ActionView::Helpers::DateHelper

  def start_at
    object.start_at.in_time_zone('London').to_s(:govuk_date)
  end

  def room
    object.room.name
  end

  def created_at
    time_ago_in_words(object.created_at.in_time_zone('London'))
  end

  def available
    object.appointment ? 'No' : 'Yes'
  end

  private

  def object
    __getobj__
  end
end
