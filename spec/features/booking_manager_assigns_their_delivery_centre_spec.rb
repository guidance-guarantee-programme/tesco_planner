require 'rails_helper'

RSpec.feature 'Booking manager assigns their delivery centre' do
  scenario 'They are already assigned' do
    given_the_user_is_identified_as_a_booking_manager do
      when_they_visit_the_application
      then_they_are_redirected_to_their_appointments
    end
  end

  scenario 'They are not yet assigned' do
    given_the_user_is_identified_as_a_booking_manager(delivery_centre: nil) do
      and_a_delivery_centre_exists
      when_they_visit_the_application
      and_they_choose_a_delivery_centre
      then_they_are_redirected_to_their_appointments
    end
  end

  def and_a_delivery_centre_exists
    @delivery_centre = create(:delivery_centre)
  end

  def when_they_visit_the_application
    visit root_path
  end

  def and_they_choose_a_delivery_centre
    page.find('.t-delivery-centres').select(@delivery_centre.name)
    page.find('.t-submit').click
  end

  def then_they_are_redirected_to_their_appointments
    expect(page.current_path).to eq(appointments_path)
  end
end
