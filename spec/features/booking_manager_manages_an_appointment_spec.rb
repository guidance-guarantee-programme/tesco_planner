# rubocop:disable Metrics/MethodLength
require 'rails_helper'

RSpec.feature 'Booking manager manages an appointment' do
  scenario 'Modifying an appointment' do
    given_the_user_is_identified_as_a_booking_manager do
      and_they_have_an_associated_appointment
      when_they_modify_the_customer_details
      then_the_details_are_changed
    end
  end

  def and_they_have_an_associated_appointment
    @appointment = appointment_for_user(@user)
  end

  def when_they_modify_the_customer_details
    @page = Pages::Appointment.new
    @page.load(id: @appointment.id)

    @page.first_name.set 'Bob'
    @page.last_name.set 'Smith'
    @page.email.set 'bob@example.com'
    @page.phone.set '07715 999 1234'
    @page.memorable_word.set 'spaceboot'
    @page.status.select 'No Show'
    @page.opt_out_of_market_research.set false
    @page.dc_pot_confirmed_dont_know.set true

    @page.submit.click
  end

  def then_the_details_are_changed
    @page = Pages::Appointments.new
    expect(@page).to be_displayed
    expect(@page).to have_success

    expect(@appointment.reload).to have_attributes(
      first_name: 'Bob',
      last_name: 'Smith',
      email: 'bob@example.com',
      phone: '07715 999 1234',
      memorable_word: 'spaceboot',
      status: 'no_show',
      opt_out_of_market_research: false,
      dc_pot_confirmed: false
    )
  end
end
