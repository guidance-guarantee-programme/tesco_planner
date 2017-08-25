class RenameAssignmentsToDeliveryCentres < ActiveRecord::Migration[5.1]
  def change
    rename_table :assignments, :delivery_centres
    remove_belongs_to :delivery_centres, :user, null: false, index: true
    add_column :delivery_centres, :name, :string, null: false, default: ''

    add_belongs_to :slots, :delivery_centre, index: true, foreign_key: true
    add_belongs_to :users, :delivery_centre, index: true, foreign_key: true
  end
end
