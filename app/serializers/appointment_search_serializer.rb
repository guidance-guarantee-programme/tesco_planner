class AppointmentSearchSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id, key: :reference
  attribute :customer_name, key: :name

  attribute :url do
    edit_appointment_url(object)
  end

  attribute :application do
    GovukAdminTemplate::Config.app_title
  end
end
