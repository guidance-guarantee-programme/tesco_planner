class AppointmentReminders
  def call
    Appointment.needing_reminder.find_each do |appointment|
      AppointmentReminderJob.perform_later(appointment)
    end
  end
end
