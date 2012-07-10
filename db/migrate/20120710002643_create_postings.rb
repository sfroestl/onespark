class CreatePostings < ActiveRecord::Migration
  def up
    create_table :postings do |t|
    	t.string :title
    	t.text :content
    	t.integer :creator_id
    	t.integer :topic_id
      t.timestamps
    end
    add_index :postings, :creator_id
    add_index :postings, :topic_id
  end

  def down
  	drop_table :postings
  end
end
