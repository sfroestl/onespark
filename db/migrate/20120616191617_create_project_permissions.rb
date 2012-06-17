class CreateProjectPermissions < ActiveRecord::Migration
  def up
    create_table :project_permissions do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :permission, :default => 0
      t.timestamps
    end
    add_index :project_permissions, :user_id
    add_index :project_permissions, :project_id
    add_index :project_permissions, [:user_id, :project_id], unique: true
  end
  def down
  	drop_table :project_permissions
  end
end
