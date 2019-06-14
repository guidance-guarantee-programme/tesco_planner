class SmsCancellationSuccessJob < SmsJobBase
  TEMPLATE_ID = '0222b5ca-265b-478a-ad89-b37bbad8acba'.freeze

  def perform(appointment) # rubocop:disable MethodLength
    return unless api_key

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
end
