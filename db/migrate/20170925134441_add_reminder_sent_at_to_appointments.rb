class AddReminderSentAtToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :reminder_sent_at, :datetime
  end
end
