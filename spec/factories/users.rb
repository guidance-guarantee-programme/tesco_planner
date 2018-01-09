require 'securerandom'

FactoryBot.define do
  factory :user, aliases: [:booking_manager] do
    uid { SecureRandom.uuid }
    name 'Rick Sanchez'
    email 'rick@example.com'
    permissions %w[signin booking_manager]

    after(:build) do |user|
      user.delivery_centres << build(:delivery_centre)
    end

    factory :unassigned_booking_manager do
      after(:build) { |user| user.assignments.clear }
    end

    factory :administrator do
      permissions %w[signin booking_manager administrator]
    end
  end
end
