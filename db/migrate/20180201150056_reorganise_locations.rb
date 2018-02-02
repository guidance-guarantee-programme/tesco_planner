class ReorganiseLocations < ActiveRecord::Migration[5.1]
  WELWYN_GARDEN_CITY_LOCATION_ID = 1
  TESCO_HQ_DELIVERY_CENTRE       = 'Tesco HQ'

  class DeliveryCentre < ApplicationRecord
    has_many :slots
    has_many :users
  end

  class Location < ApplicationRecord
    has_many :delivery_centres
  end

  def up
    if @location = Location.find_by(id: WELWYN_GARDEN_CITY_LOCATION_ID)
      # create the new DC to amalgamate existing HQ DC
      @hq = DeliveryCentre.find_or_create_by!(
        name: TESCO_HQ_DELIVERY_CENTRE,
        location_id: WELWYN_GARDEN_CITY_LOCATION_ID,
        reply_to: 'hq@tesco.pensionwise.gov.uk'
      )

      # move users and slots to the new HQ DC
      @old_delivery_centres = DeliveryCentre
        .where(location_id: WELWYN_GARDEN_CITY_LOCATION_ID)
        .where.not(name: TESCO_HQ_DELIVERY_CENTRE)

      @old_delivery_centres.each do |dc|
        dc.users.update_all(delivery_centre_id: @hq.id)
        dc.slots.update_all(delivery_centre_id: @hq.id)
      end
    end

    # assign locations to delivery centres
    add_column :locations, :delivery_centre_id, :integer, index: true
    Location.reset_column_information
    Location.where(delivery_centre_id: nil).find_each do |location|
      location.update_attribute(:delivery_centre_id, location.delivery_centres.first.id)
    end
    # assign location to the new HQ delivery centre
    @location.reload.update_attribute(:delivery_centre_id, @hq.id) if @location

    # delete the orphaned delivery centres
    @old_delivery_centres.destroy_all if defined?(@old_delivery_centres)
  end

  def down
    # noop
  end
end
