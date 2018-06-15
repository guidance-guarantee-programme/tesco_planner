class SmsCancellationSuccessJob < SmsJobBase
  TEMPLATE_ID = '0222b5ca-265b-478a-ad89-b37bbad8acba'.freeze

  def perform(appointment)
    return unless api_key

    sms_client.send_sms(
      phone_number: appointment.phone,
      template_id: TEMPLATE_ID,
      reference: appointment.to_param
    )
  end
end
