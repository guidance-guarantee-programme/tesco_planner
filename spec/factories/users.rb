require 'securerandom'

FactoryBot.define do
  factory :user, aliases: [:booking_manager] do
    uid { SecureRandom.uuid }
    name { 'Rick Sanchez' }
    email { 'rick@example.com' }
    permissions { %w[signin booking_manager] }
    delivery_centre { build(:delivery_centre, :with_locations) }

    factory :administrator do
      permissions { %w[signin booking_manager administrator] }
    end

    factory :orphaned_user do
      permissions { %w[signin] }
    end
  end
end
