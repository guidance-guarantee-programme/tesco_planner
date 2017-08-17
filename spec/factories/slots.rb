FactoryGirl.define do
  factory :slot do
    start_at { Time.current }
    end_at { start_at.advance(hours: 1) }
  end
end
