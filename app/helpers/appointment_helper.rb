module AppointmentHelper
  def grouped_delivery_centres(locations)
    locations.map do |location|
      [
        location.name,
        location.delivery_centres.pluck(:name, :id)
      ]
    end
  end

  def grouped_slots(slots)
    [].tap do |result|
      grouped = slots.group_by { |slot| slot.start_at.to_date.to_s(:govuk_date) }

      grouped.map { |day, day_slots| result << [day, grouped_day(day_slots)] }
    end
  end

  def grouped_day(day_slots)
    day_slots.uniq(&:start_at).map do |day_slot|
      [day_slot.start_at.in_time_zone('London').to_s(:govuk_time), day_slot.id]
    end
  end

  def field_with_errors_wrapper(form, field, klass)
    error_class = form.object.errors[field].any? ? "field_with_errors #{klass}" : klass

    content_tag(:div, class: error_class) { yield }
  end

  def required_label(field = nil)
    content_tag(:span, field.to_s.humanize) +
      content_tag(:span, '*', class: 'text-danger', 'aria-hidden': true) +
      content_tag(:span, 'Required', class: 'sr-only')
  end

  def friendly_options(statuses)
    statuses.map { |k, _| [k.titleize, k] }.to_h
  end
end
