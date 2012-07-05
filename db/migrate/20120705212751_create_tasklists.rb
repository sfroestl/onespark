class CreateTasklists < ActiveRecord::Migration
  def up
    create_table :tasklists do |t|
			t.text :title
			t.text :desc
      t.date :due_date
      t.integer :creator_id
      t.integer :project_id
      t.timestamps
    end
    add_index :tasklists, :creator_id
		add_index :tasklists, :project_id
  end

  def down
  	drop_table :tasklists
  end
end
