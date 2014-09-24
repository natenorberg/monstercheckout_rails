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

ActiveRecord::Schema.define(version: 20140924150714) do

  create_table "equipment", force: true do |t|
    t.string   "name"
    t.string   "brand"
    t.integer  "quantity"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.boolean  "is_kit"
  end

  create_table "equipment_permissions", id: false, force: true do |t|
    t.integer "equipment_id"
    t.integer "permission_id"
  end

  add_index "equipment_permissions", ["equipment_id", "permission_id"], name: "index_equipment_permissions_on_equipment_id_and_permission_id"

  create_table "permissions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_users", id: false, force: true do |t|
    t.integer "permission_id"
    t.integer "user_id"
  end

  add_index "permissions_users", ["permission_id", "user_id"], name: "index_permissions_users_on_permission_id_and_user_id"

  create_table "reservation_equipment", force: true do |t|
    t.integer "reservation_id"
    t.integer "equipment_id"
    t.integer "quantity"
  end

  add_index "reservation_equipment", ["equipment_id"], name: "index_reservation_equipment_on_equipment_id"
  add_index "reservation_equipment", ["reservation_id", "equipment_id"], name: "index_reservation_equipment_on_reservation_id_and_equipment_id", unique: true
  add_index "reservation_equipment", ["reservation_id"], name: "index_reservation_equipment_on_reservation_id"

  create_table "reservations", force: true do |t|
    t.string   "project"
    t.datetime "in_time"
    t.datetime "out_time"
    t.datetime "checked_out_time"
    t.datetime "checked_in_time"
    t.boolean  "is_approved"
    t.text     "check_out_comments"
    t.text     "check_in_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "checked_out_by_id"
    t.integer  "checked_in_by_id"
    t.integer  "status"
    t.boolean  "is_denied"
    t.datetime "admin_response_time"
  end

  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "reservations_sub_items", id: false, force: true do |t|
    t.integer "reservation_id"
    t.integer "sub_item_id"
  end

  add_index "reservations_sub_items", ["reservation_id", "sub_item_id"], name: "index_reservations_sub_items_on_reservation_id_and_sub_item_id"

  create_table "sub_items", force: true do |t|
    t.string   "name"
    t.string   "brand"
    t.integer  "kit_id"
    t.text     "description"
    t.boolean  "is_optional"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_items", ["kit_id"], name: "index_sub_items_on_kit_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "is_admin",                  default: false
    t.boolean  "is_monitor"
    t.boolean  "notify_on_approval_needed"
    t.boolean  "notify_on_approved"
    t.boolean  "notify_on_denied"
    t.boolean  "notify_on_checked_out"
    t.boolean  "notify_on_checked_in"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
