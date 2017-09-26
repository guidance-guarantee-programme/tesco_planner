class AddActiveToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :active, :boolean, default: true, null: false
  end
end
