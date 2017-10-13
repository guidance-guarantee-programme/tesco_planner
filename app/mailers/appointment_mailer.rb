class AppointmentMailer < ApplicationMailer
  default subject: 'Your Tesco Pension Wise Appointment'

  def reminder(appointment)
    @appointment = appointment

    mailgun_headers(:reminder, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to
  end

  def cancellation(appointment)
    @appointment = appointment

    mailgun_headers(:cancellation, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to
  end

  def customer(appointment)
    @appointment = appointment

    mailgun_headers(:confirmation, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to
  end

  def booking_manager(booking_manager)
    mail to: booking_manager.email, subject: 'Tesco Pension Wise Appointment'
  end
end
