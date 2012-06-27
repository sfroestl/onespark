class CreateToolsGithubRepositories < ActiveRecord::Migration
  def change
    create_table :tools_github_repositories do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :url
      t.string :name
      t.string :owner

      t.timestamps
    end
    add_index :tools_github_repositories, :project_id
    add_index :tools_github_repositories, :user_id
  end
end
