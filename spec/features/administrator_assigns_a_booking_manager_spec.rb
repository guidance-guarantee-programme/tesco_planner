require 'rails_helper'

RSpec.feature 'Administrator assigns a booking manager' do
  scenario 'Assigning a booking manager to a delivery centre' do
    given_the_user_is_identified_as_an_administrator do
      and_an_unassigned_booking_manager_exists
      when_the_booking_manager_is_assigned
      then_the_booking_manager_can_access_the_assigned_dc
    end
  end

  def and_an_unassigned_booking_manager_exists
    @delivery_centre = @user.delivery_centre
    @location = @user.location

    @unassigned = create(:booking_manager, name: 'Bob Smith', delivery_centre: nil)
  end

  def when_the_booking_manager_is_assigned
    @page = Pages::Admin::EditDeliveryCentre.new
    @page.load(location_id: @location.id, id: @delivery_centre.id)

    @page.booking_managers.select('Bob Smith')
    @page.submit.click
  end

  def then_the_booking_manager_can_access_the_assigned_dc
    expect(@page).to have_assigned_booking_managers(count: 2)

    expect(@page.assigned_booking_managers.first).to have_text('Bob Smith')
  end
end
