require 'rails_helper'

RSpec.describe AppointmentMailer do
  let(:appointment) { create(:appointment, :with_slot) }

  describe '#customer' do
    subject do
      travel_to '2017-09-16 13:00 UTC' do
        described_class.customer(appointment)
      end
    end

    it 'contains the necessary detail' do
      expect(subject.to).to match_array('rick@example.com')

      subject.body.encoded.tap do |body|
        expect(body).to include('Dear Rick')
        expect(body).to include('16 September 2017')
        expect(body).to include('2:00pm')
        expect(body).to include('Room no.')
      end
    end

    it 'ensures replies are directed to the DC alias' do
      expect(subject.reply_to).to match_array(appointment.delivery_centre.reply_to)
    end
  end

  describe '#cancellation' do
    subject { described_class.cancellation(appointment) }

    it 'contains the necessary detail' do
      expect(subject.to).to match_array('rick@example.com')

      subject.body.encoded.tap do |body|
        expect(body).to include('Dear Rick')
        expect(body).to include('Reference number')
      end
    end

    it 'ensures replies are directed to the DC alias' do
      expect(subject.reply_to).to match_array(appointment.delivery_centre.reply_to)
    end
  end
end
