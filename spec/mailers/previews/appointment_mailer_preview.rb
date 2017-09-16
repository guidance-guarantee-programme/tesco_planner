class AppointmentMailerPreview < ActionMailer::Preview
  def booking_manager
    AppointmentMailer.booking_manager(User.first)
  end

  def customer
    @appointment = Appointment.first

    AppointmentMailer.customer(@appointment)
  end
end
