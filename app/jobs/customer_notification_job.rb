class CustomerNotificationJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    AppointmentMailer.customer(appointment).deliver_now
  end
end
