require 'rails_helper'

RSpec.feature 'Booking manager reschedules appointment' do
  scenario 'Successfully rescheduling an appointment' do
    travel_to '2017-09-21 13:00UTC' do
      given_the_user_is_identified_as_a_booking_manager do
        and_an_appointment_exists
        and_another_slot_exists
        when_they_reschedule_the_appointment
        then_the_appointment_is_rescheduled
        and_the_customer_is_notified
      end
    end
  end

  def and_an_appointment_exists
    @appointment = appointment_for_user(@user)
  end

  def and_another_slot_exists
    @slot = slot_for_user(@user)
  end

  def when_they_reschedule_the_appointment
    @page = Pages::RescheduleAppointment.new
    @page.load(appointment_id: @appointment.id)

    @page.slots.select('2:00pm')
    @page.submit.click
  end

  def then_the_appointment_is_rescheduled
    @page = Pages::Appointments.new
    expect(@page).to be_displayed
    expect(@page).to have_success

    expect(@appointment.reload.slot_id).to eq(@slot.id)
  end

  def and_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.first.to).to match_array(@appointment.email)
  end
end
