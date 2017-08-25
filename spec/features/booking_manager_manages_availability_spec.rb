require 'rails_helper'

RSpec.feature 'Booking manager manages availability' do
  scenario 'Managing existing slots for a given location', js: true do
    travel_to '2017-08-11 13:00' do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_an_assigned_location_with_availability
        and_slots_from_another_delivery_centre
        when_they_view_availability_for_their_location
        then_they_see_the_associated_rooms
        and_they_see_the_slots_for_their_location
        when_they_click_an_existing_slot
        then_the_slot_is_removed
        when_they_click_a_slot_from_another_delivery_centre
        then_the_slot_is_not_removed
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
    @location.rooms.first.slots << build(:slot, delivery_centre: @user.delivery_centre)
    # this will be hidden
    @location.rooms.first.slots << build(
      :slot,
      start_at: 1.month.from_now,
      delivery_centre: @user.delivery_centre
    )
  end

  def and_slots_from_another_delivery_centre
    @other_delivery_centre = create(:delivery_centre, location: @user.location)

    create(
      :slot,
      delivery_centre: @other_delivery_centre,
      room: @user.location.rooms.first,
      start_at: 2.hours.from_now
    )
  end

  def when_they_view_availability_for_their_location
    @page = Pages::Availability.new
    @page.load
  end

  def then_they_see_the_associated_rooms
    expect(@page).to have_rooms
  end

  def and_they_see_the_slots_for_their_location
    @page.wait_until_slots_visible

    expect(@page).to have_slots(count: 2)
  end

  def when_they_click_an_existing_slot
    @page.dismiss_confirmations

    @page.slots.first.click
  end

  def then_the_slot_is_removed
    expect(@page).to have_success
  end

  def and_they_add_a_slot_on_a_given_day
    # switch to day view so we can find the slot easily
    @page.day.click

    @page.click_slot('09:30')
  end

  def then_the_slot_is_created
    @page.wait_until_slots_visible
    expect(@page).to have_slots(count: 1)
  end

  def when_they_click_a_slot_from_another_delivery_centre
    @page.dismiss_confirmations

    @page.wait_until_slots_visible
    @page.slots.first.click
  end

  def then_the_slot_is_not_removed
    expect(@page).to have_slots(count: 1)
  end
end
