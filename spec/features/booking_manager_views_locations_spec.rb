require 'rails_helper'

RSpec.feature 'Booking manager views locations', js: true do
  scenario 'Viewing locations' do
    given_the_user_is_identified_as_a_booking_manager do
      when_they_view_the_locations
      then_they_see_the_typeahead
    end
  end

  def when_they_view_the_locations
    @page = Pages::Locations.new.tap(&:load)
  end

  def then_they_see_the_typeahead
    expect(@page).to be_displayed
    expect(@page).to have_select2
  end
end
