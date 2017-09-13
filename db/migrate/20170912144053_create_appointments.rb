class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :slot, null: false, index: { unique: true }, foreign_key: true

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :memorable_word, null: false
      t.string :type_of_appointment, null: false
      t.date :date_of_birth, null: false
      t.integer :status, default: 0, null: false
      t.boolean :opt_out_of_market_research, default: false, null: false
      t.boolean :dc_pot_confirmed, default: true, null: false

      t.timestamps null: false
    end
  end
end
