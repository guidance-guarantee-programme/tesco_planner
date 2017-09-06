require 'rails_helper'

RSpec.describe Slot do
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
