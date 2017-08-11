require 'rails_helper'

RSpec.feature 'Booking manager manages availability' do
  scenario 'Viewing existing slots for a given location', js: true do
    travel_to '2017-08-11 13:00' do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_an_assigned_location
        when_they_view_availability_for_their_location
        then_they_see_the_associated_rooms
        and_they_see_the_slots_for_their_location
      end
    end
  end

  def and_they_have_an_assigned_location
    @location = create(:location)

    @user.locations << @location
  end

  def when_they_view_availability_for_their_location
    @page = Pages::Availability.new
    @page.load(location_id: @location.id)
  end

  def then_they_see_the_associated_rooms
    expect(@page).to have_rooms
  end

  def and_they_see_the_slots_for_their_location
    skip
  end
end
