require 'rails_helper'

RSpec.describe 'POST /mailgun/drops' do
  scenario 'inbound hooks create activity entries' do
    with_a_configured_token('deadbeef') do
      given_an_appointment
      when_mailgun_posts_a_drop_notification
      then_an_activity_is_created
      and_the_service_responds_ok
    end
  end

  def with_a_configured_token(token)
    existing = ENV['MAILGUN_API_TOKEN']

    ENV['MAILGUN_API_TOKEN'] = token
    yield
  ensure
    ENV['MAILGUN_API_TOKEN'] = existing
  end

  def given_an_appointment
    @appointment = create(:appointment, :with_slot)
  end

  def when_mailgun_posts_a_drop_notification
    post mailgun_drops_path, params: {
      'event'          => 'dropped',
      'description'    => 'the reasoning',
      'environment'    => 'production',
      'message_type'   => 'confirmation',
      'appointment_id' => @appointment.to_param,
      'timestamp'      => '1474638633',
      'token'          => 'secret',
      'signature'      => 'abf02bef01e803bea52213cb092a31dc2174f63bcc2382ba25732f4c84e084c1'
    }
  end

  def then_an_activity_is_created
    expect(DropActivity.last.appointment).to eq(@appointment)
  end

  def and_the_service_responds_ok
    expect(response).to be_success
  end
end
