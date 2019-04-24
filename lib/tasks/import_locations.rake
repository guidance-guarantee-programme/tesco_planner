require 'open-uri'
require 'csv'

namespace :import do
  desc 'Import locations via the provided CSV'
  task locations: :environment do
    csv_url = ENV.fetch('CSV')
    timeout = ENV.fetch('TIMEOUT') { 60 }.to_i
    data    = open(csv_url, read_timeout: timeout).read

    ActiveRecord::Base.transaction do
      CSV.new(data, headers: true, return_headers: false).each do |row|
        delivery_centre = DeliveryCentre.find_by(name: row[0])

        raise "Could not find: #{row[0]}" unless delivery_centre

        location = delivery_centre.locations.find_or_create_by(
          name: row[2].to_s,
          address_line_one: row[3].to_s,
          address_line_two: row[4].to_s,
          address_line_three: row[5].to_s,
          town: row[6].to_s,
          county: row[7].to_s,
          postcode: row[8].to_s
        )

        location.rooms.find_or_create_by(name: 'Colleague Area')

        puts "Created location: #{location.name}"
      end
    end
  end
end
