class EmailActivity < Activity
  def self.from(appointment)
    return if appointment.past?

    PusherNotificationJob.perform_later(super)
  end
end
