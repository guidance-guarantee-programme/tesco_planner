require 'rails_helper'

RSpec.describe SlotDecorator do
  describe '#start_at' do
    it 'respects timezones' do
      slot = SlotDecorator.new(
        build(:slot, start_at: Time.zone.parse('2018-01-01 13:00'))
      )

      expect(slot.start_at).to eq('1:00pm, 1 January 2018')

      slot = SlotDecorator.new(
        build(:slot, start_at: Time.zone.parse('2018-04-01 13:00'))
      )

      expect(slot.start_at).to eq('2:00pm, 1 April 2018')
    end
  end
end
