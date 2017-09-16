class AppointmentMailer < ApplicationMailer
  def customer(appointment)
    @appointment = appointment

    mail to: appointment.email, subject: 'Your Tesco Pension Wise Appointment'
  end

  def booking_manager(booking_manager)
    mail to: booking_manager.email, subject: 'Tesco Pension Wise Appointment'
  end
end
