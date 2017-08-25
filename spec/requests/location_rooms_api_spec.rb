require 'rails_helper'

RSpec.describe 'GET /rooms.json' do
  scenario 'Retrieving rooms as JSON' do
    given_the_user_is_identified_as_a_booking_manager do
      when_they_request_the_rooms
      then_the_service_responds_ok
      and_the_rooms_are_serialized_as_json
    end
  end

  def when_they_request_the_rooms
    get rooms_path, as: :json
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
