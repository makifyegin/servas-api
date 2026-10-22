# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_22_223755) do
  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "index_countries_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_groups_on_parent_id"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hydra_sub", null: false
    t.integer "region_id"
    t.string "status", default: "amiko", null: false
    t.index ["hydra_sub"], name: "index_members_on_hydra_sub", unique: true
    t.index ["region_id"], name: "index_members_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_regions_on_country_id"
    t.index ["name", "country_id"], name: "index_regions_on_name_and_country_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "user_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "region_id"
    t.index ["group_id"], name: "index_roles_on_group_id"
    t.index ["region_id"], name: "index_roles_on_region_id"
  end

  add_foreign_key "countries", "groups"
  add_foreign_key "groups", "groups", column: "parent_id"
  add_foreign_key "members", "regions"
  add_foreign_key "regions", "countries"
  add_foreign_key "roles", "groups"
  add_foreign_key "roles", "regions"
end
