class CreateEmployersAndAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :employers do |t|
      t.string :name, null: false, default: ''

      t.timestamps null: false
    end

    create_join_table :employers, :delivery_centres, table_name: :assignments do |t|
      t.index :employer_id
      t.index :delivery_centre_id
    end

    add_reference :locations, :employer, index: true
  end
end
