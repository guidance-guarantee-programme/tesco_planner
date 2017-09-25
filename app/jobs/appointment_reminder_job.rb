class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    AppointmentMailer.reminder(appointment).deliver_now

    appointment.touch(:reminder_sent_at) # rubocop:disable Rails/SkipsModelValidations
  end
end
