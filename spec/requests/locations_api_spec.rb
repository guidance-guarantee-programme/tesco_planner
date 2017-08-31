require 'rails_helper'

RSpec.describe 'GET /api/v1/locations.json' do
  scenario 'Requesting the locations' do
    given_locations_exist
    when_a_client_requests_locations
    then_the_service_responds_ok
    and_the_locations_are_serialized_as_json
  end

  def given_locations_exist
    @hq    = create(:location, name: 'Tesco Headquarters')
    @other = create(:location, name: 'Tesco Inverness')
  end

  def when_a_client_requests_locations
    get api_v1_locations_path, as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_locations_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json.length).to eq(2)

      expect(json.first['name']).to eq(@hq.name)

      expect(json.first.keys).to match_array(
        %w[id name address_line_one address_line_two address_line_three town county postcode]
      )
    end
  end
end
