require 'rails_helper'

RSpec.describe SlackPingerJob, '#perform' do
  let(:webhook) { double(WebHook, call: true) }

  before do
    ENV['APPOINTMENTS_SLACK_PINGER_URI'] = 'bleh'

    allow(WebHook).to receive(:new).and_return(webhook)
  end

  after do
    ENV['APPOINTMENTS_SLACK_PINGER_URI'] = nil
  end

  it 'calls the webhook with a JSON payload' do
    appointment = create(:appointment, :with_slot)

    subject.perform(appointment)

    expect(webhook).to have_received(:call).with(
      hash_including(text: %r{Tesco \d+ 1/1})
    )
  end
end
