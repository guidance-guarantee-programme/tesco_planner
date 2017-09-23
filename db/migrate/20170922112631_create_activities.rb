class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :appointment, index: true, foreign_key: true
      t.string :message, null: false, default: ''
      t.timestamps null: false
    end
  end
end
