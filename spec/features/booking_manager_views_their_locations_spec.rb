require 'rails_helper'

RSpec.feature 'Booking manager views their locations' do
  scenario 'Viewing locations' do
    given_the_user_is_identified_as_a_booking_manager do
      and_they_have_assigned_locations
      and_unassigned_locations_exist
      when_they_view_their_assigned_locations
      then_they_see_the_correct_locations
    end
  end

  def given_the_user_is_identified_as_a_booking_manager
    @user = create(:booking_manager)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def and_they_have_assigned_locations
    @location = create(:location)

    @user.locations << @location
  end

  def and_unassigned_locations_exist
    @unassigned_location = create(:location, name: 'Unassigned')
  end

  def when_they_view_their_assigned_locations
    @page = Pages::Locations.new.tap(&:load)
  end

  def then_they_see_the_correct_locations
    expect(@page).to be_displayed
    expect(@page).to have_locations(count: 1)

    @page.locations.first.tap do |location|
      expect(location.name.text).to eq(@location.name)
      expect(location.town.text).to eq(@location.town)
    end
  end
end
