require 'rails_helper'

RSpec.feature 'Administrator manages locations' do
  scenario 'Creating a new location' do
    given_the_user_is_identified_as_an_administrator do
      when_they_attempt_to_create_a_location
      and_complete_the_required_fields
      then_the_location_is_created
    end
  end

  def when_they_attempt_to_create_a_location
    @page = Pages::Admin::Location.new.tap(&:load)
  end

  def and_complete_the_required_fields
    @page.name.set('Tesco HQ')
    @page.address_line_one.set('10 Downing Street')
    @page.town.set('London Town')
    @page.county.set('London')
    @page.postcode.set('W1 1AW')
    @page.submit.click
  end

  def then_the_location_is_created
    expect(Location.last).to have_attributes(
      name: 'Tesco HQ',
      address_line_one: '10 Downing Street',
      town: 'London Town',
      county: 'London',
      postcode: 'W1 1AW'
    )
  end
end
