require 'notifications/client'

class SmsAppointmentReminderJob < ApplicationJob
  queue_as :default

  TEMPLATE_ID = 'd7dcd977-f3fa-42a5-a5ca-110d0ac8e05e'.freeze

  rescue_from(Notifications::Client::RequestError) do |exception|
    Bugsnag.notify(exception)
  end

  def perform(appointment)
    return unless api_key

    send_sms_reminder(appointment)

    SmsReminderActivity.from(appointment)
  end

  private

  def send_sms_reminder(appointment)
    appointment = AppointmentDecorator.new(appointment)

    sms_client.send_sms(
      phone_number: appointment.phone,
      template_id: TEMPLATE_ID,
      reference: appointment.to_param,
      personalisation: {
        date: appointment.slot,
        location: appointment.location_name
      }
    )
  end

  def sms_client
    @sms_client ||= Notifications::Client.new(api_key)
  end

  def api_key
    ENV['NOTIFY_API_KEY']
  end
end
