# rubocop:disable Metrics/MethodLength
require 'rails_helper'

RSpec.describe 'POST /api/v1/locations/:location_id/appointments' do
  scenario 'Attempting to create an invalid appointment' do
    travel_to '2017-09-12 13:00 UTC' do
      given_a_location_with_availability
      when_an_invalid_appointment_request_is_made
      then_the_service_responds_unprocessable
    end
  end

  scenario 'Creating a valid appointment' do
    travel_to '2017-09-12 13:00 UTC' do
      given_a_location_with_availability
      when_an_appointment_request_is_made
      then_the_service_responds_created
      and_the_appointment_is_identified_by_the_location_header
      and_the_appointment_is_created
      and_the_booking_managers_are_notified
      and_the_customer_is_notified
    end
  end

  def given_a_location_with_availability
    create(:booking_manager) do |user|
      @location = user.location
      @slot = @location.rooms.first.slots << build(
        :slot,
        start_at: Time.current.advance(days: 1),
        delivery_centre: user.delivery_centre
      )
    end
  end

  def when_an_appointment_request_is_made
    @payload = {
      'start_at'         => '2017-09-13T13:00:00.000Z',
      'first_name'       => 'Rick',
      'last_name'        => 'Sanchez',
      'email'            => 'rick@example.com',
      'phone'            => '02082524729',
      'memorable_word'   => 'snootboop',
      'date_of_birth'    => '1950-02-02',
      'dc_pot_confirmed' => true,
      'opt_out_of_market_research' => true
    }

    path = api_v1_location_appointments_path(location_id: @location.id)
    post path, params: @payload, as: :json
  end

  def then_the_service_responds_created
    expect(response).to be_created
  end

  def and_the_appointment_is_identified_by_the_location_header
    @appointment = Appointment.last

    expect(response.headers['Location']).to end_with(appointment_path(@appointment))
  end

  def and_the_appointment_is_created
    expect(@appointment).to have_attributes(
      first_name: 'Rick',
      last_name: 'Sanchez',
      email: 'rick@example.com',
      phone: '02082524729',
      memorable_word: 'snootboop',
      type_of_appointment: '55-plus',
      date_of_birth: Date.parse('1950-02-02'),
      dc_pot_confirmed: true,
      opt_out_of_market_research: true,
      status: 'pending'
    )
  end

  def and_the_booking_managers_are_notified
    assert_enqueued_jobs(1, only: BookingManagerNotificationJob)
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs(1, only: CustomerNotificationJob)
  end

  def when_an_invalid_appointment_request_is_made
    @payload = {
      'start_at'         => '2017-09-15T13:00:00.000Z',
      'first_name'       => 'Rick',
      'last_name'        => 'Sanchez',
      'email'            => 'rick@example.com',
      'phone'            => '02082524729',
      'memorable_word'   => 'snootboop',
      'date_of_birth'    => '1950-02-02',
      'dc_pot_confirmed' => true,
      'opt_out_of_market_research' => true
    }

    path = api_v1_location_appointments_path(location_id: @location.id)
    post path, params: @payload, as: :json
  end

  def then_the_service_responds_unprocessable
    expect(response).to be_unprocessable
  end
end
