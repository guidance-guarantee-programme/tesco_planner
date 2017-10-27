FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room no.#{n}" }

    trait :with_location do
      location
    end
  end
end
