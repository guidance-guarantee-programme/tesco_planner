require 'rails_helper'

RSpec.feature 'Administrator creates a delivery centre' do
  scenario 'Creating a delivery centre' do
    given_the_user_is_identified_as_an_administrator do
      when_they_create_a_delivery_centre
      then_the_delivery_centre_is_created
    end
  end

  def when_they_create_a_delivery_centre
    @page = Pages::Admin::DeliveryCentre.new
    @page.load

    @page.name.set('Stevenage')
    @page.reply_to.set('stevenage@example.com')
    @page.submit.click
  end

  def then_the_delivery_centre_is_created
    expect(DeliveryCentre.last).to have_attributes(
      name: 'Stevenage',
      reply_to: 'stevenage@example.com'
    )
  end
end
