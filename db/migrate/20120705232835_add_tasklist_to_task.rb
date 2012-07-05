class AddTasklistToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :tasklist_id, :integer
  end
end
