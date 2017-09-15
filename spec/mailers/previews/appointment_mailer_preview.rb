class AppointmentMailerPreview < ActionMailer::Preview
  def booking_manager
    AppointmentMailer.booking_manager(User.first)
  end
end
