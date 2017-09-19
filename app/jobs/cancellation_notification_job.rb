class CancellationNotificationJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    return unless appointment.future?

    AppointmentMailer.cancellation(appointment).deliver_now
  end
end
