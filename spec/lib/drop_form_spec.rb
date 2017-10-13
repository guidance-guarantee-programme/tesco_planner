require 'rails_helper'

RSpec.describe DropForm, '#create_activity' do
  let(:appointment) { create(:appointment, :with_slot) }
  let(:params) do
    {
      'event'          => 'dropped',
      'description'    => 'the reasoning',
      'appointment_id' => appointment.to_param,
      'environment'    => 'production',
      'message_type'   => 'confirmation',
      'timestamp'      => '1474638633',
      'token'          => 'secret',
      'signature'      => 'abf02bef01e803bea52213cb092a31dc2174f63bcc2382ba25732f4c84e084c1'
    }
  end
  let(:token) { 'deadbeef' }

  around do |example|
    begin
      existing = ENV['MAILGUN_API_TOKEN']

      ENV['MAILGUN_API_TOKEN'] = token
      example.run
    ensure
      ENV['MAILGUN_API_TOKEN'] = existing
    end
  end

  subject { described_class.new(params) }

  context 'when the signature is not verified' do
    it 'raises an error' do
      params['signature'] = 'whoops'

      expect { subject.create_activity }.to raise_error(TokenVerificationFailure)
    end
  end

  context 'when the signature is verified' do
    it 'requires production environment' do
      params['environment'] = 'staging'

      expect(subject).not_to be_valid
    end

    it 'requires an event' do
      params.delete('event')

      expect(subject).not_to be_valid
    end

    it 'requires an appointment' do
      params['appointment_id'] = '999'

      expect { subject.create_activity }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'requires a message type' do
      params.delete('message_type')

      expect(subject).not_to be_valid
    end

    context 'when everything is validated' do
      it 'creates the drop activity' do
        subject.create_activity

        expect(DropActivity.last).to have_attributes(
          message: 'confirmation - the reasoning',
          appointment: appointment
        )
      end
    end
  end
end
