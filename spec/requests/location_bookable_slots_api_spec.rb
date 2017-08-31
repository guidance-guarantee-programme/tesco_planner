# rubocop:disable Metrics/MethodLength
require 'rails_helper'

RSpec.describe 'GET /slots?start=date&end=date' do
  scenario 'Requesting the slots' do
    travel_to '2017-08-11 13:00' do
      given_the_user_is_identified_as_a_booking_manager do
        and_the_location_has_slots
        when_they_request_the_slots_for_their_location
        then_the_service_responds_ok
        and_the_slots_are_serialized_as_json
      end
    end
  end

  def and_the_location_has_slots
    @room = @user.location.rooms.first

    @dates = [
      '2017-08-14 13:00',
      '2017-08-14 15:30',
      '2017-08-15 11:00',
      '2017-08-18 09:00',
      '2017-10-01 10:00'
    ].each do |date|
      @room.slots << build(
        :slot,
        start_at: Time.zone.parse(date),
        delivery_centre: @user.delivery_centre
      )
    end
  end

  def when_they_request_the_slots_for_their_location
    get slots_path(
      start: Date.current.beginning_of_month,
      end: Date.current.end_of_month
    ), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_slots_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json.count).to eq(4)

      expect(json.first.keys).to match_array(%w[id start end resourceId])
    end
  end
end
