FactoryGirl.define do
  factory :room do
    sequence(:name) { |n| "Room no.#{n}" }
  end
end
