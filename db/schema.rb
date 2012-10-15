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

ActiveRecord::Schema.define(:version => 20120721114035) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "friendships", ["friend_id", "user_id"], :name => "index_friendships_on_friend_id_and_user_id"
  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "postings", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "creator_id"
    t.integer  "topic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  add_index "postings", ["creator_id"], :name => "index_postings_on_creator_id"
  add_index "postings", ["project_id"], :name => "index_postings_on_project_id"
  add_index "postings", ["topic_id"], :name => "index_postings_on_topic_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "forename"
    t.string   "surname"
    t.string   "city"
    t.text     "about"
    t.string   "avatar_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "project_coworkers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "permission", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "project_coworkers", ["project_id", "user_id"], :name => "index_project_coworkers_on_project_id_and_user_id", :unique => true
  add_index "project_coworkers", ["project_id"], :name => "index_project_coworkers_on_project_id"
  add_index "project_coworkers", ["user_id"], :name => "index_project_coworkers_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.datetime "due_date"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasklists", :force => true do |t|
    t.text     "title"
    t.text     "desc"
    t.date     "due_date"
    t.integer  "creator_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tasklists", ["creator_id"], :name => "index_tasklists_on_creator_id"
  add_index "tasklists", ["project_id"], :name => "index_tasklists_on_project_id"

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "milestone_id"
    t.string   "title"
    t.text     "desc"
    t.datetime "due_date"
    t.integer  "creator_id"
    t.integer  "worker_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "tasklist_id"
    t.boolean  "completed"
    t.datetime "completed_at"
    t.integer  "completed_by"
  end

  add_index "tasks", ["creator_id"], :name => "index_tasks_on_creator_id"
  add_index "tasks", ["milestone_id"], :name => "index_tasks_on_milestone_id"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["worker_id"], :name => "index_tasks_on_worker_id"

  create_table "tools_github_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tools_github_accounts", ["user_id"], :name => "index_tools_github_accounts_on_user_id"

  create_table "tools_github_repositories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "url"
    t.string   "name"
    t.string   "owner"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tools_github_repositories", ["project_id"], :name => "index_tools_github_repositories_on_project_id"
  add_index "tools_github_repositories", ["user_id"], :name => "index_tools_github_repositories_on_user_id"

  create_table "topics", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "project_id"
    t.string   "title"
    t.text     "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "topics", ["creator_id"], :name => "index_topics_on_creator_id"
  add_index "topics", ["project_id"], :name => "index_topics_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
