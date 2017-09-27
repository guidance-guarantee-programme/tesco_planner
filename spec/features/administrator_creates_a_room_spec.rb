require 'rails_helper'

RSpec.feature 'Administrator creates a room' do
  scenario 'Creating a room' do
    given_the_user_is_identified_as_an_administrator do
      and_a_location_exists
      when_they_add_a_room_to_the_location
      then_the_room_is_added
    end
  end

  def and_a_location_exists
    @location = create(:location)
  end

  def when_they_add_a_room_to_the_location
    @page = Pages::Admin::Room.new
    @page.load(location_id: @location.id)

    @page.name.set('Room 42')
    @page.submit.click
  end

  def then_the_room_is_added
    expect(Room.last).to have_attributes(
      name: 'Room 42',
      location_id: @location.id
    )
  end
end
