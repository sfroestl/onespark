# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120616221808) do

  create_table "github_accounts", :force => true do |t|
    t.string   "access_token"
    t.integer  "app_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "github_accounts", ["user_id"], :name => "index_github_accounts_on_user_id"

  create_table "milestones", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.text     "goal"
    t.date     "due_date"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "milestones", ["user_id"], :name => "index_milestones_on_owner_id"

  create_table "project_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "permission", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "project_permissions", ["project_id"], :name => "index_project_permissions_on_project_id"
  add_index "project_permissions", ["user_id", "project_id"], :name => "index_project_permissions_on_user_id_and_project_id", :unique => true
  add_index "project_permissions", ["user_id"], :name => "index_project_permissions_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.datetime "due_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
