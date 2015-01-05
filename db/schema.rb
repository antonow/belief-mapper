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

ActiveRecord::Schema.define(version: 20150105210637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "belief_stats", force: true do |t|
    t.integer  "stat_id"
    t.integer  "belief_id"
    t.integer  "user_count"
    t.integer  "avg_conviction"
    t.integer  "comment_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beliefs", force: true do |t|
    t.string   "name"
    t.string   "definition"
    t.string   "resource"
    t.integer  "category_id"
    t.integer  "user_count",     default: 0
    t.integer  "avg_conviction", default: 0
    t.boolean  "starred",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "beliefs", ["slug"], name: "index_beliefs_on_slug", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes"
    t.integer  "comment_id"
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree

  create_table "connections", force: true do |t|
    t.integer  "belief_1_id"
    t.integer  "belief_2_id"
    t.integer  "count",              default: 0
    t.integer  "strong_connections", default: 0
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
    t.string   "gender_sorted"
    t.string   "religion_sorted"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "stats", force: true do |t|
    t.integer  "user_count"
    t.integer  "comment_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_beliefs", force: true do |t|
    t.integer  "user_id"
    t.integer  "belief_id"
    t.integer  "conviction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "skipped",    default: false
  end

  add_index "user_beliefs", ["belief_id"], name: "index_user_beliefs_on_belief_id", using: :btree
  add_index "user_beliefs", ["user_id"], name: "index_user_beliefs_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "unique_url"
    t.boolean  "active",                 default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answered_questions",     default: 0
    t.boolean  "admin",                  default: false
    t.string   "username",               default: "guest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
