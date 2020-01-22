class AddUrlToEmployers < ActiveRecord::Migration[5.2]
  def change
    add_column :employers, :url, :string, null: false, default: ''
  end
end
