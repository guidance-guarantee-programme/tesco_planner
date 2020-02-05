require 'rails_helper'

RSpec.describe 'GET /api/v1/locations/:location_id' do
  scenario 'Requesting an inactive location' do
    given_the_location_exists
    and_it_is_inactive
    when_a_request_for_an_inactive_location_is_made
    then_the_service_responds_with_a_404
  end

  scenario 'Requesting the given location' do
    travel_to @now = Time.zone.parse('2017-09-06 13:00') do
      given_the_location_exists
      and_it_has_multiple_rooms
      and_it_has_associated_slots
      when_the_location_is_requested
      then_the_service_responds_ok
      and_the_location_is_serialized_as_json
    end
  end

  def and_it_is_inactive
    @location.update(active: false)
  end

  def when_a_request_for_an_inactive_location_is_made
    get api_v1_location_path(@location), as: :json
  end

  def then_the_service_responds_with_a_404
    expect(response).to be_missing
  end

  def given_the_location_exists
    @location = create(:booking_manager).location
  end

  def and_it_has_multiple_rooms
    @room_one = @location.rooms.first
    @room_two = create(:room, location: @location)
  end

  def and_it_has_associated_slots
    @delivery_centre_one = @location.delivery_centre
    # won't appear as it occurs today
    @today = create(:slot, room: @room_one, start_at: @now)
    # appears singularly
    @tomorrow = create(:slot, room: @room_one, start_at: @now.advance(days: 1))
    # will be combined into a single slot
    @combined = create(:slot, room: @room_one, start_at: @now.advance(weeks: 1))
    # will be combined with the slot above
    @other_combined = create(:slot, room: @room_two, start_at: @now.advance(weeks: 1))

    # this won't appear as it has an associated appointment
    @other_slot = create(:slot, room: @room_one, start_at: @now.advance(weeks: 1, hours: 1))
    create(:appointment, slot: @other_slot)
  end

  def when_the_location_is_requested
    get api_v1_location_path(@location), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_location_is_serialized_as_json
    JSON.parse(response.body).tap do |json|
      slots = json['windowed_slots']
      expect(slots.keys).to match_array(%w[2017-09-07 2017-09-13])

      expect(slots['2017-09-07']).to match_array(%w[2017-09-07T13:00:00.000Z])
      expect(slots['2017-09-13']).to match_array(%w[2017-09-13T13:00:00.000Z])
    end
  end
end
