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

ActiveRecord::Schema.define(version: 2018_10_20_102030) do
  create_table "protosite_pages", id: :string, force: :cascade do |t|
    t.string "parent_id"
    t.string "slug"
    t.integer "sort"
    t.boolean "published", default: false, null: false
    t.json "data", default: {}, null: false
    t.json "versions", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_protosite_pages_on_slug"
  end

  create_table "protosite_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "authentication_token", null: false
    t.string "password_digest"
    t.json "permissions", default: {}, null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_token"], name: "index_protosite_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_protosite_users_on_email", unique: true
  end
end
