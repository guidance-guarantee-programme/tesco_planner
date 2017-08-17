class CreateSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :slots do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.belongs_to :room, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
