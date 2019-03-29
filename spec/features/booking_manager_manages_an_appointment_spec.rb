# rubocop:disable Metrics/MethodLength
require 'rails_helper'

RSpec.feature 'Booking manager manages an appointment' do
  scenario 'Modifying an appointment' do
    perform_enqueued_jobs do
      travel_to 2.days.ago do # so the appointment is not `past?`
        given_the_user_is_identified_as_a_booking_manager do
          and_they_have_an_associated_appointment
          when_they_modify_the_customer_details
          then_the_details_are_changed
          and_the_customer_is_notified
        end
      end
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
      travel_to 2.days.ago do # so the appointment is not `past?`
        given_the_user_is_identified_as_a_booking_manager do
          and_they_have_an_associated_appointment
          when_the_appointment_is_cancelled
          then_the_customer_is_notified
          and_the_original_slot_is_still_available
        end
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
    @page.gdpr_consent_no.set true
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
      gdpr_consent: 'no',
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
    expect(@appointment.activities.first).to be_an(EmailActivity)

    expect(ActionMailer::Base.deliveries.first.to).to match_array(@appointment.email)
  end
  alias_method :and_the_customer_is_notified, :then_the_customer_is_notified

  def and_the_original_slot_is_still_available
    expect(
      Slot.available.find_by(start_at: @appointment.slot.start_at)
    ).to be
  end
end
