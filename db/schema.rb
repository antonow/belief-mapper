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

ActiveRecord::Schema.define(version: 20141201193658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beliefs", force: true do |t|
    t.string   "name"
    t.string   "definition"
    t.string   "resource"
    t.integer  "category_id"
    t.integer  "user_count",     default: 0
    t.integer  "avg_conviction"
    t.boolean  "starred",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", force: true do |t|
    t.integer  "belief_1_id"
    t.integer  "belief_2_id"
    t.integer  "count",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demographics", force: true do |t|
    t.string   "gender"
    t.integer  "age"
    t.string   "religion"
    t.string   "country"
    t.string   "state"
    t.string   "education_level"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_beliefs", force: true do |t|
    t.integer  "user_id"
    t.integer  "belief_id"
    t.integer  "conviction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_beliefs", ["belief_id"], name: "index_user_beliefs_on_belief_id", using: :btree
  add_index "user_beliefs", ["user_id"], name: "index_user_beliefs_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
