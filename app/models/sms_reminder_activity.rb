class SmsReminderActivity < Activity
  def self.from(appointment)
    create!(appointment: appointment)
  end
end
