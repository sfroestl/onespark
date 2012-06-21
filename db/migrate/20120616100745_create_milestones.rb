class CreateMilestones < ActiveRecord::Migration
  def up
    create_table :milestones do |t|
      t.string :title
      t.text :desc
      t.text :goal
      t.date :due_date
      t.integer :project_id

      t.timestamps
    end
  end
  
  def down
    drop_table :milestones
  end
end
