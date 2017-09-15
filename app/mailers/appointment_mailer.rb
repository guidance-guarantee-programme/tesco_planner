class AppointmentMailer < ApplicationMailer
  def booking_manager(booking_manager)
    mail to: booking_manager.email, subject: 'Tesco Pension Wise Appointment'
  end
end
