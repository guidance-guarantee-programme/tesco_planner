require 'rails_helper'

RSpec.describe 'GET /appointments.json?start={start}&end={end}' do
  scenario 'Requesting the appointments' do
    travel_to '2017-09-20 13:00UTC' do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_associated_appointments
        when_they_request_the_appointments_json
        then_the_service_responds_ok
        and_the_appointments_are_serialized_as_json
      end
    end
  end

  def and_they_have_associated_appointments
    @appointment = appointment_for_user(@user)
  end

  def when_they_request_the_appointments_json
    get location_appointments_path(
      @appointment.location,
      start: Date.current.beginning_of_month,
      end: Date.current.end_of_month
    ), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_appointments_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json.first.keys).to match_array(
        %w[id title resourceId start end cancelled url]
      )
    end
  end
end
