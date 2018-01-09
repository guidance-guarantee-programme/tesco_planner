class CreateAssignments < ActiveRecord::Migration[5.1]
  def up
    create_table :assignments do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :delivery_centre, index: true, foreign_key: true
    end

    User.where.not(delivery_centre_id: nil).find_each do |user|
      Assignment.create!(user: user, delivery_centre: user.delivery_centre)
    end
  end

  def down
    drop_table :assignments
  end
end
