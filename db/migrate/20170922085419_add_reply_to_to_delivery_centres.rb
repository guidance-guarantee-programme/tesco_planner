class AddReplyToToDeliveryCentres < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_centres, :reply_to, :string, null: false, default: ''
  end
end
