class CreateLinkedAccounts < ActiveRecord::Migration
  def change
    create_table :linked_accounts do |t|
      t.string :name
      t.string :username
      t.string :password
      t.integer :user_id

      t.timestamps
    end
    add_index :linked_accounts, :user_id
  end
end
