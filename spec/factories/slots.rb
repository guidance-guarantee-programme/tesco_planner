FactoryBot.define do
  factory :slot do
    start_at { Time.current }
    end_at { start_at.advance(hours: 1) }

    trait :with_room do
      room { build(:room, :with_location) }
    end
  end
end
