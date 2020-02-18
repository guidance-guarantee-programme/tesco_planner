require 'rails_helper'

RSpec.describe Appointment, 'Validation' do
  describe '#booking_managers' do
    it 'does not include regular, permissionless users' do
      appointment = create(:appointment, :with_slot)
      # this will not appear as it has no `booking_manager` permission
      create(:orphaned_user, delivery_centre: appointment.delivery_centre)

      expect(appointment.booking_managers).to be_empty

      # this will appear as it has the right permission
      create(:user, delivery_centre: appointment.delivery_centre)

      expect(appointment.booking_managers).not_to be_empty
    end
  end

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

  describe '#notify?' do
    subject { create(:appointment, :with_slot) }

    context 'when the status was changed' do
      it 'handles correctly' do
        travel_to 2.days.ago do
          subject.update(status: :complete)
          expect(subject).to_not be_notify

          subject.update(status: :pending)
          expect(subject).to be_notify
        end
      end

      context 'when the appointment has elapsed' do
        it 'is false' do
          expect(subject).not_to be_notify
        end
      end
    end

    context 'when the status was not changed' do
      it 'returns true' do
        travel_to 2.days.ago do
          subject.update(first_name: 'George')

          expect(subject).to be_notify
        end
      end
    end
  end
end
