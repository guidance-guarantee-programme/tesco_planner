FactoryBot.define do
  factory :delivery_centre do
    sequence(:name) { |n| "Delivery Centre #{n}" }
    reply_to { 'dc@example.com' }
    hidden { false }

    trait :hidden do
      hidden { true }
    end

    trait :with_locations do
      after(:build) { |dc| dc.locations << build(:location) }
    end
  end
end
