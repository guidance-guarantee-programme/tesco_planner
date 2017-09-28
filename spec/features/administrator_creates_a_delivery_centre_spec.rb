require 'rails_helper'

RSpec.feature 'Administrator creates a delivery centre' do
  scenario 'Creating a delivery centre' do
    given_the_user_is_identified_as_an_administrator do
      and_a_location_exists
      when_they_add_a_delivery_centre_to_the_location
      then_the_delivery_centre_is_added
    end
  end

  def and_a_location_exists
    @location = create(:location)
  end

  def when_they_add_a_delivery_centre_to_the_location
    @page = Pages::Admin::DeliveryCentre.new
    @page.load(location_id: @location.id)

    @page.name.set('Stevenage')
    @page.reply_to.set('stevenage@example.com')
    @page.submit.click
  end

  def then_the_delivery_centre_is_added
    expect(DeliveryCentre.last).to have_attributes(
      name: 'Stevenage',
      reply_to: 'stevenage@example.com',
      location_id: @location.id
    )
  end
end
