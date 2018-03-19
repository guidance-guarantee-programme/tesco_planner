require 'rails_helper'

RSpec.feature 'Appointment reminders' do
  scenario 'Sending scheduled appointment reminders' do
    perform_enqueued_jobs do
      given_an_appointment_exists_and_is_due_a_reminder
      when_the_scheduled_job_runs
      then_the_reminder_is_sent
      and_the_appointment_is_marked_as_reminded
    end
  end

  def given_an_appointment_exists_and_is_due_a_reminder
    @appointment      = build(:appointment)
    @appointment.slot = build(:slot, :with_room, start_at: 36.hours.from_now)

    @appointment.save!
  end

  def when_the_scheduled_job_runs
    AppointmentReminders.new.call
  end

  def then_the_reminder_is_sent
    expect(ActionMailer::Base.deliveries.first.to).to match_array(@appointment.email)
  end

  def and_the_appointment_is_marked_as_reminded
    expect(@appointment.reload).to be_reminder_sent_at
  end
end
