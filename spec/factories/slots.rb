FactoryBot.define do
  factory :slot do
    start_at { Time.current }
    end_at { start_at.advance(hours: 1) }

    trait :with_room do
      delivery_centre
      room { delivery_centre.locations.first.rooms.first }
    end
  end
end
