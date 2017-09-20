class AppointmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id

  attribute :title do
    "#{object.first_name} #{object.last_name}"
  end

  attribute :resourceId do
    object.slot.room_id
  end

  attribute :start do
    object.slot.start_at
  end

  attribute :end do
    object.slot.end_at
  end

  attribute :cancelled do
    object.cancelled?
  end

  attribute :url do
    edit_appointment_path(object)
  end
end
