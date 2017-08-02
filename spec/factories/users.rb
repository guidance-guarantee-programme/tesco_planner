require 'securerandom'

FactoryGirl.define do
  factory :user, aliases: [:guider] do
    uid { SecureRandom.uuid }
    name 'Rick Sanchez'
    email 'rick@example.com'

    factory :booking_manager do
      permissions %w(signin booking_manager)
    end
  end
end
