class AppointmentMailer < ApplicationMailer
  default subject: 'Your Tesco Pension Wise Appointment'

  def cancellation(appointment)
    @appointment = appointment

    mail to: appointment.email
  end

  def customer(appointment)
    @appointment = appointment

    mail to: appointment.email
  end

  def booking_manager(booking_manager)
    mail to: booking_manager.email, subject: 'Tesco Pension Wise Appointment'
  end
end
