class AppointmentMailer < ApplicationMailer
  default subject: 'Your Employer Pension Wise Appointment'

  def booking_manager_cancellation(booking_manager, appointment)
    @appointment = appointment

    mailgun_headers(:booking_manager_cancellation, appointment)
    mail to: booking_manager.email, subject: 'Employer Pension Wise Appointment SMS Cancellation'
  end

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
    mail to: booking_manager.email, subject: 'Employer Pension Wise Appointment'
  end
end
