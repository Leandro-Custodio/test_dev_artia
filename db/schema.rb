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

ActiveRecord::Schema[8.0].define(version: 2025_07_28_002939) do
  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.boolean "status"
    t.date "start_date"
    t.date "end_date"
    t.integer "kind"
    t.float "completed_percent"
    t.integer "priority"
    t.integer "urgency"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "filter_conditions", force: :cascade do |t|
    t.integer "filter_group_id", null: false
    t.string "field"
    t.string "operator"
    t.string "value"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_group_id"], name: "index_filter_conditions_on_filter_group_id"
  end

  create_table "filter_configurations", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_operator"
    t.index ["user_id"], name: "index_filter_configurations_on_user_id"
  end

  create_table "filter_groups", force: :cascade do |t|
    t.integer "filter_configuration_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "operator"
    t.index ["filter_configuration_id"], name: "index_filter_groups_on_filter_configuration_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "activities", "users"
  add_foreign_key "filter_conditions", "filter_groups"
  add_foreign_key "filter_configurations", "users"
  add_foreign_key "filter_groups", "filter_configurations"
end
