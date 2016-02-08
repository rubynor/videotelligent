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

ActiveRecord::Schema.define(version: 20160204191050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",               null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "external_reference"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "content_providers", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.string   "uid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "expires_at"
    t.string   "refresh_token"
  end

  add_index "content_providers", ["uid"], name: "index_content_providers_on_uid", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.boolean "is_interesting"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "uid"
    t.string   "provider"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "link"
    t.string   "title"
    t.datetime "published_at"
    t.integer  "likes"
    t.integer  "dislikes"
    t.string   "uid"
    t.string   "thumbnail_url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "views"
    t.string   "description"
    t.string   "tags"
    t.string   "channel_title"
    t.integer  "views_last_week", default: 0
    t.integer  "category_id"
    t.string   "channel_id"
  end

  add_index "videos", ["category_id"], name: "index_videos_on_category_id", using: :btree
  add_index "videos", ["uid"], name: "index_videos_on_uid", using: :btree

  create_table "view_stats", force: :cascade do |t|
    t.integer  "video_id"
    t.string   "country"
    t.string   "gender"
    t.string   "age_group"
    t.integer  "number_of_views"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "on_date"
  end

  add_index "view_stats", ["age_group"], name: "index_view_stats_on_age_group", using: :btree
  add_index "view_stats", ["country"], name: "index_view_stats_on_country", using: :btree
  add_index "view_stats", ["gender"], name: "index_view_stats_on_gender", using: :btree
  add_index "view_stats", ["on_date"], name: "index_view_stats_on_on_date", using: :btree
  add_index "view_stats", ["video_id"], name: "index_view_stats_on_video_id", using: :btree

end
