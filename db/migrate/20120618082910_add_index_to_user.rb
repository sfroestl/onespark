class AddIndexToUser < ActiveRecord::Migration
  def change
  	rename_column :users, :name, :username
  	add_index :profiles, :user_id
  	add_index :friendships, :user_id  	
  	add_index :friendships, :friend_id
  	add_index :friendships, [:friend_id, :user_id]
  	add_index :friendships, [:user_id, :friend_id]
  	add_index :users, :username, unique: true
  end
end
