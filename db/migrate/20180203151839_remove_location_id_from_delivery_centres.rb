class RemoveLocationIdFromDeliveryCentres < ActiveRecord::Migration[5.1]
  def change
    remove_belongs_to :delivery_centres, :location, index: true, foreign_key: true
  end
end
