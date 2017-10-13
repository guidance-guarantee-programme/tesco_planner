class AddTypeToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :type, :string, null: false, default: '', index: true

    Activity.update_all(type: 'MessageActivity')
  end
end
