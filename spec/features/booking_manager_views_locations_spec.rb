require 'rails_helper'

RSpec.feature 'Booking manager views locations' do
  scenario 'Viewing locations' do
    given_the_user_is_identified_as_a_booking_manager do
      when_they_view_the_locations
      then_the_page_is_loaded
    end
  end

  def when_they_view_the_locations
    @page = Pages::Locations.new.tap(&:load)
  end

  def then_the_page_is_loaded
    expect(@page).to be_displayed
  end
end
