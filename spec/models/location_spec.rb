require 'rails_helper'

RSpec.describe Location, 'Validation' do
  it 'is valid with valid attributes' do
    expect(build(:location)).to be_valid
  end

  it 'requires an associated delivery centre' do
    expect(build(:location, delivery_centre: nil)).to be_invalid
  end
end
