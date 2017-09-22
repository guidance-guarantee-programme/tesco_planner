class AppointmentMailer < ApplicationMailer
  default subject: 'Your Tesco Pension Wise Appointment'

  def cancellation(appointment)
    @appointment = appointment

    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to
  end

  def customer(appointment)
    @appointment = appointment

    mail to: appointment.email, reply_to: appointment.delivery_centre.reply_to
  end

  def booking_manager(booking_manager)
    mail to: booking_manager.email, subject: 'Tesco Pension Wise Appointment'
  end
end
