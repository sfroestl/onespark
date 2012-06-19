class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :forename
      t.string :surname
      t.string :city
      t.text :about
      t.string :avatar_url
      t.timestamps
    end
  end

  def down
    drop_table :profiles
  end
end
