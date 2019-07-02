require 'rails_helper'

RSpec.feature 'Administrator manages locations' do
  scenario 'Creating a new location' do
    given_the_user_is_identified_as_an_administrator do
      and_an_employer_exists
      and_a_delivery_centre_exists
      when_they_attempt_to_create_a_location
      and_complete_the_required_fields
      then_the_location_is_created
    end
  end

  def and_an_employer_exists
    @employer = create(:employer, name: 'Tesco')
  end

  def and_a_delivery_centre_exists
    @delivery_centre = create(:delivery_centre, name: 'Unassigned DC')
  end

  def when_they_attempt_to_create_a_location
    @page = Pages::Admin::Location.new.tap(&:load)
  end

  def and_complete_the_required_fields
    @page.employer.select('Tesco')
    @page.delivery_centre.select('Unassigned DC')
    @page.name.set('Tesco HQ')
    @page.address_line_one.set('10 Downing Street')
    @page.town.set('London Town')
    @page.county.set('London')
    @page.postcode.set('W1 1AW')
    @page.submit.click
  end

  def then_the_location_is_created
    expect(Location.last).to have_attributes(
      employer_id: @employer.id,
      delivery_centre_id: @delivery_centre.id,
      name: 'Tesco HQ',
      address_line_one: '10 Downing Street',
      town: 'London Town',
      county: 'London',
      postcode: 'W1 1AW'
    )
  end
end
