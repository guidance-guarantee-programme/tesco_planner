class BookingManagerSmsCancellationJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    appointment.booking_managers.each do |recipient|
      AppointmentMailer.booking_manager_cancellation(recipient, appointment).deliver_later
    end
  end
end
