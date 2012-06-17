class RenameOwnerId < ActiveRecord::Migration
  def up
  	rename_column(:projects, :owner_id, :user_id)
  	rename_column(:milestones, :owner_id, :user_id)
  end
end
