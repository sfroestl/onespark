class AddProjectIdToPostings < ActiveRecord::Migration
  def change
  	add_column :postings, :project_id, :integer
  	
  	add_index :postings, :project_id
  end
end
