class SmsAppointmentReminderJob < SmsJobBase
  TEMPLATE_ID = 'd7dcd977-f3fa-42a5-a5ca-110d0ac8e05e'.freeze

  def perform(appointment)
    return unless api_key

    send_sms_reminder(appointment)

    SmsReminderActivity.from(appointment)
  end

  private

  def send_sms_reminder(appointment) # rubocop:disable MethodLength
    appointment = AppointmentDecorator.new(appointment)

    sms_client.send_sms(
      phone_number: appointment.phone,
      template_id: TEMPLATE_ID,
      reference: appointment.to_param,
      personalisation: {
        date: appointment.slot,
        location: appointment.location_name,
        employer: appointment.employer_name
      }
    )
  end
end
