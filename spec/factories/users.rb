require 'securerandom'

FactoryGirl.define do
  factory :user, aliases: [:booking_manager] do
    uid { SecureRandom.uuid }
    name 'Rick Sanchez'
    email 'rick@example.com'
    permissions %w(signin booking_manager)
    delivery_centre
  end
end
