class CreateProjectCoworkers < ActiveRecord::Migration
  def up
    create_table :project_coworkers do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :permission, :default => 0
      t.timestamps
    end
    add_index :project_coworkers, :user_id
    add_index :project_coworkers, :project_id
    add_index :project_coworkers, [:project_id, :user_id], unique: true
  end
  def down
  	drop_table :project_coworkers
  end
end
