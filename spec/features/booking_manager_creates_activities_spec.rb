require 'rails_helper'

RSpec.feature 'Booking manager creates activities' do
  scenario 'Creating a message activity', js: true do
    given_the_user_is_identified_as_a_booking_manager do
      and_there_is_an_appointment
      when_they_view_the_appointment
      and_they_leave_a_message
      then_they_see_their_new_message
      and_the_message_field_is_cleared
    end
  end

  def and_there_is_an_appointment
    @appointment = appointment_for_user(@user)
  end

  def when_they_view_the_appointment
    @page = Pages::Appointment.new
    @page.load(id: @appointment.id)
  end

  def and_they_leave_a_message
    @page.message.set('Customer called to cancel.')
    @page.submit_message.click
  end

  def then_they_see_their_new_message
    @page.wait_until_activities_visible

    expect(@page).to have_activities(count: 1)
  end

  def and_the_message_field_is_cleared
    expect(@page.message).to have_text('')
  end
end
