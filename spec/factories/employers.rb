FactoryBot.define do
  factory :employer do
    sequence(:name) { |n| "Employer #{n}" }

    url { 'employer-url-fragment' }
  end
end
