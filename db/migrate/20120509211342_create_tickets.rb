class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :desc
      t.references :project
      t.datetime :due_date

      t.timestamps
    end
    add_index :tickets, :project_id
  end
end
