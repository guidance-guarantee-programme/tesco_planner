FactoryGirl.define do
  factory :delivery_centre do
    location

    sequence(:name) { |n| "Delivery Centre #{n}" }
  end
end
