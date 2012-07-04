class CreateTopics < ActiveRecord::Migration
  def up
    create_table :topics do |t|
      t.integer :creator_id
      t.integer :project_id
      t.string :title
      t.text :desc

      t.timestamps
    end
    add_index :topics, :project_id
    add_index :topics, :creator_id
  end

  def down
  	drop_table :topics
  end
end
