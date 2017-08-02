class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false, default: ''
      t.belongs_to :location, index: true

      t.timestamps null: false
    end
  end
end
