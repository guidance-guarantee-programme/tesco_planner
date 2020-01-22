require 'rails_helper'

RSpec.feature 'Managing employers' do
  scenario 'Administrator creates an employer' do
    given_the_user_is_identified_as_an_administrator do
      and_a_delivery_centre_exists
      when_the_administrator_creates_an_employer
      then_the_employer_is_created
      and_the_cloudflare_redirect_is_enqueued
    end
  end

  def and_a_delivery_centre_exists
    @dc = create(:delivery_centre)
  end

  def when_the_administrator_creates_an_employer
    @page = Pages::Admin::Employer.new
    @page.load

    @page.name.set 'An Employer'
    @page.url_fragment.set 'an-employer'
    @page.delivery_centres.select @dc.name

    @page.submit.click
  end

  def then_the_employer_is_created
    @page = Pages::Admin::Employers.new
    expect(@page).to be_displayed
    expect(@page).to have_success

    expect(@page).to have_employers
    expect(@page.employers.first.name).to have_text('An Employer')
    expect(@page.employers.first.url).to have_text('an-employer')
    expect(@page.employers.first.delivery_centres).to have_text(@dc.name)
  end

  def and_the_cloudflare_redirect_is_enqueued
    assert_enqueued_jobs(1, only: CloudflareEmployerRedirectJob)
  end
end
