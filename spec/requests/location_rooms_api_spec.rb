require 'rails_helper'

RSpec.describe 'GET /locations/:location_id/rooms.json' do
  scenario 'Retrieving rooms as JSON' do
    given_the_user_is_identified_as_a_booking_manager do
      and_they_have_an_assigned_location
      when_they_request_the_rooms_for_their_location
      then_the_service_responds_ok
      and_the_rooms_are_serialized_as_json
    end
  end

  def and_they_have_an_assigned_location
    @location = create(:location)

    @user.locations << @location
  end

  def when_they_request_the_rooms_for_their_location
    get location_rooms_path(@location), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_rooms_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json.first.keys).to match_array(%w(id title))
    end
  end
end
