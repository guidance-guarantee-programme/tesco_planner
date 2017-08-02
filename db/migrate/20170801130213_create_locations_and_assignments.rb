class CreateLocationsAndAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false, default: ''
      t.string :address_line_one, null: false, default: ''
      t.string :address_line_two, null: false, default: ''
      t.string :address_line_three, null: false, default: ''
      t.string :town, null: false, default: ''
      t.string :county, null: false, default: ''
      t.string :postcode, null: false, default: ''

      t.timestamps null: false
    end

    create_table :assignments do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :location, index: true, foreign_key: true

      t.index %i(user_id location_id), unique: true

      t.timestamps null: false
    end
  end
end
