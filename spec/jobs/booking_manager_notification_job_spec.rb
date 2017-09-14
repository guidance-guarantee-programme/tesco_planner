require 'rails_helper'

RSpec.describe BookingManagerNotificationJob, '#perform' do
  it 'delivers an email to the given booking manager' do
    booking_manager = build(:booking_manager)

    subject.perform(booking_manager)

    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
