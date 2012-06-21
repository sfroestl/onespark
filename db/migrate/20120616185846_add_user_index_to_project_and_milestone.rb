class AddOwnerIndexToProjectAndMilestone < ActiveRecord::Migration
  def change
  	add_column :projects, :user_id, :integer
  	add_column :milestones, :user_id, :integer
  end
end
