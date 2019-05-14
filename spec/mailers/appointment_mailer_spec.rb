require 'rails_helper'

RSpec.describe AppointmentMailer do
  let(:appointment) { create(:appointment, :with_slot) }
  let(:mailgun_headers) { JSON.parse(subject['X-Mailgun-Variables'].value) }

  describe 'SMS cancellation' do
    let(:booking_manager) { create(:booking_manager, delivery_centre: appointment.delivery_centre) }

    subject(:mail) { described_class.booking_manager_cancellation(booking_manager, appointment) }

    it 'is identified for mailgun' do
      expect(mailgun_headers).to include('message_type' => 'booking_manager_cancellation')
    end

    it 'renders the headers' do
      expect(mail.subject).to match(/Employer \d+ Pension Wise Appointment SMS Cancellation/)
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.to_param)
        expect(body).to include("/appointments/#{appointment.id}/edit")
      end
    end
  end

  describe '#reminder' do
    subject do
      travel_to '2017-09-16 13:00 UTC' do
        described_class.reminder(appointment)
      end
    end

    it 'is identified for mailgun' do
      expect(mailgun_headers).to include('message_type' => 'reminder')
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

  describe '#customer' do
    subject do
      travel_to '2017-09-16 13:00 UTC' do
        described_class.customer(appointment)
      end
    end

    it 'is identified for mailgun' do
      expect(mailgun_headers).to include('message_type' => 'confirmation')
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

    context 'when tesco' do
      it 'contains the customised tesco content' do
        allow(appointment).to receive(:tesco?).and_return(true)

        expect(subject.body.encoded).to include('Tesco Benefit Report')
      end
    end

    context 'when not tesco' do
      it 'does not contain the customised tesco content' do
        allow(appointment).to receive(:tesco?).and_return(false)

        expect(subject.body.encoded).not_to include('Tesco Benefit Report')
      end
    end
  end

  describe '#cancellation' do
    subject { described_class.cancellation(appointment) }

    it 'is identified for mailgun' do
      expect(mailgun_headers).to include('message_type' => 'cancellation')
    end

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
