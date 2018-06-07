require 'rails_helper'

RSpec.feature 'Administrator searches for an appointment by reference' do
  scenario 'Viewing an appointment', js: true do
    given_the_user_is_identified_as_an_administrator do
      when_they_search_for_an_appointment
      then_they_are_presented_with_the_appointment
    end
  end

  scenario 'Attempting to search when not an administrator' do
    given_the_user_is_identified_as_a_booking_manager do
      they_do_not_see_the_quick_search
    end
  end

  def they_do_not_see_the_quick_search
    visit '/'

    expect(page).to have_no_css('.t-quick-search')
  end

  def when_they_search_for_an_appointment
    @appointment = create(:appointment, :with_slot)

    visit '/'
    find(:css, '.t-quick-search').click
    fill_in 'quick-search-input', with: @appointment.id
    find(:css, '.t-quick-search-button').click
  end

  def then_they_are_presented_with_the_appointment
    expect(page.current_path).to eq(edit_appointment_path(@appointment))
  end
end
