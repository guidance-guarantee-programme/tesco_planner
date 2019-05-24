require 'rails_helper'

RSpec.describe Slot do
  describe 'Validation' do
    it 'is valid with valid attributes' do
      expect(build(:slot, :with_room)).to be_valid
    end

    it 'validates uniqueness of slots' do
      travel_to '2018-01-01 13:00' do
        # Don't allow available duplicates
        @slot = create(:slot, :with_room)
        expect(build(:slot, room: @slot.room)).to be_invalid

        # Don't allow overlapping, available duplicates
        expect(
          build(:slot, start_at: Time.zone.parse('2018-01-01 13:30'), room: @slot.room)
        ).to be_invalid

        # Allow duplicates without availability
        @appointment = create(:appointment, :with_slot)
        expect(build(:slot, room: @appointment.room)).to be_valid
      end
    end
  end

  describe 'Inferring `end_at`' do
    context 'when `end_at` is not present' do
      it 'is inferred from the `start_at`' do
        slot = described_class.new(start_at: '2017-01-01 13:00')

        slot.validate

        expect(slot.end_at).to eq('2017-01-01 14:00')
      end
    end

    context 'when `end_at` is present' do
      it 'is not inferred' do
        slot = described_class.new(
          start_at: '2017-01-01 13:00',
          end_at: '2017-01-01 15:00'
        )

        slot.validate

        expect(slot.end_at).to eq('2017-01-01 15:00')
      end
    end
  end
end
