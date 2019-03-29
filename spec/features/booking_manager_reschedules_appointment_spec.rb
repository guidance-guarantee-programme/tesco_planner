require 'rails_helper'

RSpec.feature 'Booking manager reschedules appointment' do
  scenario 'Successfully rescheduling an appointment' do
    perform_enqueued_jobs do
      travel_to '2017-09-21 13:00UTC' do
        given_the_user_is_identified_as_a_booking_manager do
          and_an_appointment_exists
          and_another_slot_exists
          when_they_edit_the_appointment
          then_they_are_offered_to_reschedule_the_appointment
          when_they_reschedule_the_appointment
          then_the_appointment_is_rescheduled
          and_the_customer_is_notified
        end
      end
    end
  end

  scenario 'Attempting to reschedule a cancelled appointment' do
    travel_to '2017-09-21 13:00UTC' do
      given_the_user_is_identified_as_a_booking_manager do
        and_a_cancelled_appointment_exists
        and_another_slot_exists
        when_they_reschedule_the_appointment
        then_they_see_a_warning
      end
    end
  end

  scenario 'Not offered to reschedule a cancelled appointment' do
    travel_to '2017-09-21 13:00UTC' do
      given_the_user_is_identified_as_a_booking_manager do
        and_a_cancelled_appointment_exists
        and_another_slot_exists
        when_they_edit_the_appointment
        then_they_are_not_offered_to_reschedule_the_appointment
      end
    end
  end

  def and_an_appointment_exists
    @appointment = appointment_for_user(@user)
  end

  def and_a_cancelled_appointment_exists
    @appointment = appointment_for_user(@user, status: :cancelled_by_pension_wise)
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

  def when_they_edit_the_appointment
    @page = Pages::Appointment.new
    @page.load(id: @appointment.id)
  end

  def then_the_appointment_is_rescheduled
    @page = Pages::Appointments.new
    expect(@page).to be_displayed
    expect(@page).to have_success

    expect(@appointment.reload.slot_id).to eq(@slot.id)
  end

  def then_they_see_a_warning
    expect(@page).to have_content('cannot be rescheduled if cancelled')
  end

  def then_they_are_offered_to_reschedule_the_appointment
    expect(find_link('2:00pm, 21 September 2017')[:class]).to_not include('disabled-link')
  end

  def then_they_are_not_offered_to_reschedule_the_appointment
    expect(find_link('2:00pm, 21 September 2017')[:class]).to include('disabled-link')
  end

  def and_the_customer_is_notified
    expect(@appointment.activities.first).to be_an(EmailActivity)

    expect(ActionMailer::Base.deliveries.first.to).to match_array(@appointment.email)
  end
end
