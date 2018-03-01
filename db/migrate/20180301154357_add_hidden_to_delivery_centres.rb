class AddHiddenToDeliveryCentres < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_centres, :hidden, :boolean, null: false, default: false
  end
end
