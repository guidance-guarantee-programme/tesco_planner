require 'rails_helper'

RSpec.describe AppointmentMailer do
  describe '#customer' do
    let(:appointment) { create(:appointment, :with_slot) }

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
  end

  describe '#cancellation' do
    subject { described_class.cancellation(build(:appointment)) }

    it 'contains the necessary detail' do
      expect(subject.to).to match_array('rick@example.com')

      subject.body.encoded.tap do |body|
        expect(body).to include('Dear Rick')
        expect(body).to include('Reference number')
      end
    end
  end
end
