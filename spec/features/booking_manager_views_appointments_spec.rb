require 'rails_helper'

RSpec.feature 'Booking manager views appointments' do
  scenario 'Viewing their assigned appointments' do
    given_the_user_is_identified_as_a_booking_manager do
      and_their_delivery_centre_has_associated_appointments
      when_they_view_the_appointments
      then_they_see_their_appointments
    end
  end

  def and_their_delivery_centre_has_associated_appointments
    @appointments = 3.times { appointment_for_user(@user) }
  end

  def when_they_view_the_appointments
    @page = Pages::Appointments.new.tap(&:load)
  end

  def then_they_see_their_appointments
    expect(@page).to be_displayed
    expect(@page).to have_appointments(count: 3)
  end
end
