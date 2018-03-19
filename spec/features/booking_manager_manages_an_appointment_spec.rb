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

  scenario 'Incorrectly modifying an appointment' do
    given_the_user_is_identified_as_a_booking_manager do
      and_they_have_an_associated_appointment
      when_they_provide_invalid_details
      then_errors_are_displayed
    end
  end

  scenario 'Cancelling an appointment' do
    perform_enqueued_jobs do
      given_the_user_is_identified_as_a_booking_manager do
        and_they_have_an_associated_appointment
        when_the_appointment_is_cancelled
        then_the_customer_is_notified
        and_the_original_slot_is_still_available
      end
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

  def when_they_provide_invalid_details
    @page = Pages::Appointment.new
    @page.load(id: @appointment.id)

    @page.first_name.set ''
    @page.last_name.set ''

    @page.submit.click
  end

  def then_errors_are_displayed
    expect(@page).to have_errors
  end

  def when_the_appointment_is_cancelled
    @page = Pages::Appointment.new
    @page.load(id: @appointment.id)

    @page.status.select 'Cancelled By Customer'
    @page.submit.click
  end

  def then_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.first.to).to match_array(@appointment.email)
  end

  def and_the_original_slot_is_still_available
    expect(
      Slot.available.find_by(start_at: @appointment.slot.start_at)
    ).to be
  end
end
