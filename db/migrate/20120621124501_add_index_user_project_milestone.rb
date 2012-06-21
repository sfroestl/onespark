class AddIndexUserProjectMilestone < ActiveRecord::Migration
  def up  	
  	add_index  :milestones, :user_id
  	add_index  :projects, :user_id
  end

  def down
  	remove_index  :milestones, :user_id
  	remove_index  :projects, :user_id
  end
end
