FactoryBot.define do
  factory :delivery_centre do
    sequence(:name) { |n| "Delivery Centre #{n}" }
    reply_to 'dc@example.com'

    trait :with_locations do
      after(:build) { |dc| dc.locations << build(:location) }
    end
  end
end
