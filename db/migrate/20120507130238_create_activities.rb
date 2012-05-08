class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :activities, :user_id
  end
end
