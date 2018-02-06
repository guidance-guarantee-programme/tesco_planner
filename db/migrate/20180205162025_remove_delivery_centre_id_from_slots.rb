class RemoveDeliveryCentreIdFromSlots < ActiveRecord::Migration[5.1]
  def change
    remove_belongs_to :slots, :delivery_centre, index: true, foreign_key: true
  end
end
