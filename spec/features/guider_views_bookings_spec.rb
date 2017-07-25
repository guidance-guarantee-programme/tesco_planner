require 'rails_helper'

RSpec.feature 'Guider views bookings' do
  scenario 'Viewing bookings when not logged in' do
    expect do
      with_real_sso { when_they_visit_the_root }
    end.to raise_error(ActionController::RoutingError)
  end

  scenario 'Viewing bookings when logged in' do
    given_the_user_is_identified_as_a_guider do
      when_they_visit_the_root
      then_they_see_the_root
    end
  end

  def given_the_user_is_identified_as_a_guider
    @user = create(:guider)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def when_they_visit_the_root
    visit root_path
  end

  def then_they_see_the_root
    expect(page).to have_content('Rick Sanchez')
  end

  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end
end
