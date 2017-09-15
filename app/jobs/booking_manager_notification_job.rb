class BookingManagerNotificationJob < ApplicationJob
  queue_as :default

  def perform(booking_manager)
    AppointmentMailer.booking_manager(booking_manager).deliver_now
  end
end
