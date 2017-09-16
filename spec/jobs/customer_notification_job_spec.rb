require 'rails_helper'

RSpec.describe CustomerNotificationJob, '#perform' do
  it 'sends the customer an email notification' do
    appointment = create(:appointment, :with_slot)

    subject.perform(appointment)

    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
