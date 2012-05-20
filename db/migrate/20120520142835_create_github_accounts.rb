class CreateGithubAccounts < ActiveRecord::Migration
  def change
    create_table :github_accounts do |t|
      t.string :access_token
      t.integer :app_id
      t.integer :user_id

      t.timestamps
    end
    add_index :github_accounts, :user_id
  end

end
