require 'rails_helper'

RSpec.describe Appointment, 'Validation' do
  %i[
    cancelled_by_customer
    cancelled_by_pension_wise
    cancelled_by_customer_sms
  ].each do |status|
    it "validates an appointment cannot be rescheduled if #{status}" do
      appointment = build(:appointment, slot_id: 1, status: status)

      appointment.update(slot_id: 2)

      expect(appointment.errors.messages[:slot]).to include('cannot be rescheduled if cancelled')
    end
  end

  describe '#should_cancel?' do
    it 'returns true when the status was not already cancelled' do
      appointment = create(:appointment, :with_slot)

      appointment.update(status: :cancelled_by_customer)
      expect(appointment).to be_should_cancel

      appointment.update(status: :cancelled_by_customer_sms)
      expect(appointment).not_to be_should_cancel
    end
  end
end
