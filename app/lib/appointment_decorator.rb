class AppointmentDecorator < SimpleDelegator
  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def status
    object.status.humanize
  end

  def slot
    object.slot.start_at.in_time_zone('London').to_s(:govuk_date)
  end

  def room
    object.slot.room.name
  end

  def object
    __getobj__
  end
end
