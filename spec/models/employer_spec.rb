require 'rails_helper'

RSpec.describe Employer do
  it 'is valid with valid attributes' do
    expect(build(:employer)).to be_valid
  end

  it 'requires a valid url' do
    expect(build(:employer, url: '/a')).to be_invalid
  end
end
