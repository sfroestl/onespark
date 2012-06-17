class AddOwnerIndexToProjectAndMilestone < ActiveRecord::Migration
  def change
  	add_column :projects, :owner_id, :integer
  	add_column :milestones, :owner_id, :integer
  	add_index  :milestones, :owner_id
  	add_index  :projects, :owner_id
  end
end
