namespace :locations do
  desc 'Disable bookings for all locations'
  task disable: :environment do
    Location.active.update_all(active: false) # rubocop:disable SkipsModelValidations
  end
end
