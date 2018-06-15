class SmsAppointmentRemindersJob < ApplicationJob
  queue_as :default

  def perform
    Appointment.needing_sms_reminder.find_each do |appointment|
      SmsAppointmentReminderJob.perform_later(appointment)
    end
  end
end
