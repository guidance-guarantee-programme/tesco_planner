require 'rails_helper'

RSpec.feature 'Booking manager searches slots' do
  scenario 'Viewing slots per month' do
    given_the_user_is_identified_as_a_booking_manager do
      and_their_location_has_associated_slots
      when_they_view_the_slots
      then_they_see_the_slots_in_their_location
    end
  end

  def and_their_location_has_associated_slots
    3.times { appointment_for_user(@user) }
  end

  def when_they_view_the_slots
    @page = Pages::Slots.new
    @page.load(location_id: @user.location.id)
  end

  def then_they_see_the_slots_in_their_location
    expect(@page).to be_displayed
    expect(@page).to have_slots(count: 3)
  end
end
