FactoryBot.define do
  factory :delivery_centre do
    reply_to 'dc@example.com'
    location

    sequence(:name) { |n| "Delivery Centre #{n}" }
  end
end
