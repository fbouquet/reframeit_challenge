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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140220105255) do

  create_table "answers", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
  end

  create_table "polls", force: true do |t|
    t.string   "title"
    t.integer  "finished"
    t.integer  "expert_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "content"
    t.integer  "poll_id"
    t.integer  "correct_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_answers_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_answers_relationships", ["answer_id"], name: "index_user_answers_relationships_on_answer_id"
  add_index "user_answers_relationships", ["user_id", "answer_id"], name: "index_user_answers_relationships_on_user_id_and_answer_id", unique: true
  add_index "user_answers_relationships", ["user_id"], name: "index_user_answers_relationships_on_user_id"

  create_table "user_poll_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_poll_relationships", ["poll_id"], name: "index_user_poll_relationships_on_poll_id"
  add_index "user_poll_relationships", ["user_id", "poll_id"], name: "index_user_poll_relationships_on_user_id_and_poll_id", unique: true
  add_index "user_poll_relationships", ["user_id"], name: "index_user_poll_relationships_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "first_name"
    t.integer  "influency"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
