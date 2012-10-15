class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :desc
      t.datetime :due_date
      t.integer :user_id

      t.timestamps
    end
  end
end
