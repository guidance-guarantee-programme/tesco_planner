require 'rails_helper'

RSpec.feature 'Booking manager manages availability' do
  scenario 'Viewing existing slots for a given location', js: true do
    travel_to '2017-08-11 13:00' do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_an_assigned_location_with_availability
        when_they_view_availability_for_their_location
        then_they_see_the_associated_rooms
        and_they_see_the_slots_for_their_location
      end
    end
  end

  def and_they_have_an_assigned_location_with_availability
    @location = create(:location) do |location|
      @user.locations << location

      # this will be visible
      location.rooms.first.slots << build(:slot)
      # this will be hidden
      location.rooms.first.slots << build(:slot, start_at: 1.month.from_now)
    end
  end

  def when_they_view_availability_for_their_location
    @page = Pages::Availability.new
    @page.load(location_id: @location.id)
  end

  def then_they_see_the_associated_rooms
    expect(@page).to have_rooms
  end

  def and_they_see_the_slots_for_their_location
    @page.wait_until_slots_visible

    expect(@page).to have_slots(count: 1)
  end
end
