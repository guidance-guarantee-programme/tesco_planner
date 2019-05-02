require 'rails_helper'

RSpec.describe 'GET /api/v1/employers/{:id}.json' do
  scenario 'Requesting the employer' do
    given_an_employer_with_locations_exists
    when_a_client_requests_the_employer
    then_the_service_responds_ok
    and_the_employer_is_serialized_as_json
  end

  def given_an_employer_with_locations_exists
    @employer = create(:employer, name: 'Tesco')
    @hq       = create(:location, employer: @employer, name: 'Tesco Headquarters')
    @other    = create(:location, employer: @employer, name: 'Tesco Inverness')
  end

  def when_a_client_requests_the_employer
    get api_v1_employer_path(@employer.to_param), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_employer_is_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json['name']).to eq('Tesco')

      expect(json['locations']).to include(
        hash_including('name' => 'Tesco Headquarters'),
        hash_including('name' => 'Tesco Inverness')
      )
    end
  end
end
