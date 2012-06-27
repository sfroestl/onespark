class CreateToolsGithubAccounts < ActiveRecord::Migration
  def change
    create_table :tools_github_accounts do |t|
      t.integer :user_id
      t.string :access_token

      t.timestamps
    end
    add_index :tools_github_accounts, :user_id
  end
end
