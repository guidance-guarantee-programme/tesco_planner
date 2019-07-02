class AppointmentMailerPreview < ActionMailer::Preview
  def reminder
    @appointment = Appointment.first

    AppointmentMailer.reminder(@appointment)
  end

  def booking_manager
    AppointmentMailer.booking_manager(User.first, Appointment.first)
  end

  def customer
    @appointment = Appointment.first

    AppointmentMailer.customer(@appointment)
  end

  def cancellation
    @appointment = Appointment.first

    AppointmentMailer.cancellation(@appointment)
  end
end
