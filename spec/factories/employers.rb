FactoryBot.define do
  factory :employer do
    sequence(:name) { |n| "Employer #{n}" }
  end
end
