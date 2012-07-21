class AddCompletedFlagToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :completed, :boolean
  	add_column :tasks, :completed_at, :datetime
  	add_column :tasks, :completed_by, :integer
  end
end
