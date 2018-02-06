require 'rails_helper'

RSpec.feature 'Booking manager manages availability' do
  scenario 'Managing existing slots for a given location', js: true do
    travel_to '2017-08-11 10:00' do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_an_assigned_location_with_availability
        and_they_have_appointments
        when_they_view_availability_for_their_location
        then_they_see_the_associated_rooms
        and_they_see_the_slots_for_their_location
        and_they_see_the_appointments_for_their_location
        when_they_click_an_existing_slot
        then_the_slot_is_removed
      end
    end
  end

  scenario 'Creating a slot for a given location', js: true do
    travel_to '2017-08-11 13:00' do
      given_the_user_is_identified_as_a_booking_manager do
        when_they_view_availability_for_their_location
        and_they_add_a_slot_on_a_given_day
        then_the_slot_is_created
      end
    end
  end

  def and_they_have_an_assigned_location_with_availability
    @location = @user.location
    # this will be visible
    @location.rooms.first.slots << build(:slot)
    # this will be hidden
    @location.rooms.first.slots << build(:slot, start_at: 1.month.from_now)
  end

  def and_they_have_appointments
    appointment_for_user(@user, start_at: 1.hour.from_now)
  end

  def and_they_see_the_appointments_for_their_location
    expect(@page).to have_appointments(count: 1)
  end

  def when_they_view_availability_for_their_location
    @page = Pages::Availability.new
    @page.load
  end

  def then_they_see_the_associated_rooms
    expect(@page).to have_rooms
  end

  def and_they_see_the_slots_for_their_location
    @page.wait_for_calendar_events

    expect(@page).to have_slots(count: 2)
  end

  def when_they_click_an_existing_slot
    @page.slots.first.click
    @page.accept_confirmation
  end

  def then_the_slot_is_removed
    @page.wait_until_success_visible
    expect(@page).to have_success
  end

  def and_they_add_a_slot_on_a_given_day
    # switch to day view so we can find the slot easily
    @page.day.click

    @page.click_slot('09:30')
  end

  def then_the_slot_is_created
    @page.wait_for_calendar_events
    expect(@page).to have_slots(count: 1)
  end
end
