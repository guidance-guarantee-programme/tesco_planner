class AppointmentMailer < ApplicationMailer
  def booking_manager_cancellation(booking_manager, appointment)
    @appointment = appointment

    mailgun_headers(:booking_manager_cancellation, appointment)
    mail to: booking_manager.email, subject: "#{appointment.employer_name} Pension Wise Appointment SMS Cancellation"
  end

  def reminder(appointment)
    @appointment = appointment

    mailgun_headers(:reminder, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to, subject: employer_subject(appointment)
  end

  def cancellation(appointment)
    @appointment = appointment

    mailgun_headers(:cancellation, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to, subject: employer_subject(appointment)
  end

  def customer(appointment)
    @appointment = appointment

    mailgun_headers(:confirmation, appointment)
    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to, subject: employer_subject(appointment)
  end

  def booking_manager(booking_manager, appointment)
    mail to: booking_manager.email, subject: "#{appointment.employer_name} Pension Wise Appointment"
  end

  private

  def employer_subject(appointment)
    "Your #{appointment.employer_name} Pension Wise Appointment"
  end
end
