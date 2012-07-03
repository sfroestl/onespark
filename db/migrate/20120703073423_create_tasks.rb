class CreateTasks < ActiveRecord::Migration
  def up
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :milestone_id
      t.string :title
      t.text :desc
      t.datetime :due_date
      t.integer :creator_id
      t.integer :worker_id

      t.timestamps
    end
    add_index :tasks, :project_id 
    add_index :tasks, :milestone_id
    add_index :tasks, :worker_id
    add_index :tasks,  :creator_id
  end

  def down
    drop_table :tasks
  end
end
