class ApplicationMailer < ActionMailer::Base
  default from: 'Tesco Pension Wise Appointments <appointments@pensionwise.gov.uk>'

  layout 'mailer'

  protected

  def mailgun_headers(message_type, appointment)
    headers['X-Mailgun-Variables'] = {
      message_type: message_type,
      appointment_id: appointment.to_param,
      environment: Rails.env
    }.to_json
  end
end
