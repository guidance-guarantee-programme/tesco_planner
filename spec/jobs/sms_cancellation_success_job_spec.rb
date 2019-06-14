require 'rails_helper'

RSpec.describe SmsCancellationSuccessJob, '#perform' do
  let(:appointment) { create(:appointment, :with_slot, phone: '07715 930 444') }
  let(:client) { double(Notifications::Client, send_sms: true) }

  it 'sends an SMS' do
    expect(client).to receive(:send_sms).with(
      phone_number: '07715 930 444',
      template_id: SmsCancellationSuccessJob::TEMPLATE_ID,
      reference: appointment.to_param,
      personalisation: {
        date: '2:00pm, 15 June 2018',
        location: a_string_matching(/\ATesco \d+/)
      }
    )

    described_class.new.perform(appointment)
  end

  before do
    ENV['NOTIFY_API_KEY'] = 'blahblah'

    allow(Notifications::Client).to receive(:new).and_return(client)

    travel_to '2018-06-15 13:00 UTC'
  end

  after do
    ENV.delete('NOTIFY_API_KEY')

    travel_back
  end
end
