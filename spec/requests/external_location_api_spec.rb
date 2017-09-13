require 'rails_helper'

RSpec.describe 'GET /api/v1/locations/:location_id' do
  scenario 'Requesting the given location' do
    travel_to @now = Time.zone.parse('2017-09-06 13:00') do
      given_the_location_exists
      and_it_has_multiple_rooms
      and_it_has_multiple_delivery_centres
      and_it_has_associated_slots
      when_the_location_is_requested
      then_the_service_responds_ok
      and_the_location_is_serialized_as_json
    end
  end

  def given_the_location_exists
    @location = create(:booking_manager).location
  end

  def and_it_has_multiple_rooms
    @room_one = @location.rooms.first
    @room_two = create(:room, location: @location)
  end

  def and_it_has_multiple_delivery_centres
    @delivery_centre_one = @location.delivery_centres.first
    @delivery_centre_two = create(:delivery_centre, location: @location)
  end

  def and_it_has_associated_slots
    # won't appear as it occurs today
    @today = build_slot(@room_one, @now, @delivery_centre_one)
    # appears singularly
    @tomorrow = build_slot(@room_one, @now.advance(days: 1), @delivery_centre_two)
    # will be combined into a single slot
    @combined = build_slot(@room_one, @now.advance(weeks: 1), @delivery_centre_one)
    # will be combined with the slot above
    @other_combined = build_slot(@room_two, @now.advance(weeks: 1), @delivery_centre_two)

    # this won't appear as it has an associated appointment
    @other_slot = build_slot(@room_one, @now.advance(weeks: 1, hours: 1), @delivery_centre_one)
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

  def build_slot(room, start_at, delivery_centre)
    build(:slot, start_at: start_at, delivery_centre: delivery_centre) do |slot|
      room.slots << slot
    end
  end
end
