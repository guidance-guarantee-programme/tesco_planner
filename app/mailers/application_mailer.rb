class ApplicationMailer < ActionMailer::Base
  default from: 'Pension Wise Appointments <appointments.pensionwise@moneyhelper.org.uk>'

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
