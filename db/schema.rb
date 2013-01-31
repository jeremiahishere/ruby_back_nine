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

ActiveRecord::Schema.define(:version => 20130131134055) do

  create_table "challenge_case", :force => true do |t|
    t.integer  "challenge_id"
    t.text     "setup"
    t.text     "expected_output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "difficult"
    t.integer  "maximum_execution_time"
    t.text     "sample_setup"
    t.string   "sample_solution"
    t.text     "sample_output"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solutions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.integer  "submitted_at"
    t.boolean  "approved"
    t.text     "code"
    t.text     "code_output"
    t.datetime "ran_at"
    t.boolean  "success"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
