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
end
