class AppointmentDecorator < SimpleDelegator
  def processed
    object.processed_at? ? 'Yes' : 'No'
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def status
    object.status.humanize
  end

  def slot
    return '' unless object.slot

    object.slot.start_at.in_time_zone('London').to_s(:govuk_date)
  end

  def room
    object.slot.room.name
  end

  def location_name
    object.slot.room.location.name
  end

  def object
    __getobj__
  end

  def to_h
    {
      id: id,
      room: room
    }
  end
end
