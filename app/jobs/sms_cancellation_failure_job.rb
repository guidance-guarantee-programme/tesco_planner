class SmsCancellationFailureJob < SmsJobBase
  TEMPLATE_ID = '66a7d499-079a-49da-8065-c794c0f2f736'.freeze

  def perform(mobile_number)
    return unless api_key

    sms_client.send_sms(
      phone_number: mobile_number,
      template_id: TEMPLATE_ID,
      reference: mobile_number
    )
  end
end
