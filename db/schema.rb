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

ActiveRecord::Schema.define(version: 20150911234403) do

  create_table "companies", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.string   "telefon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id"

  create_table "costumers", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "address"
    t.string   "telefon"
    t.string   "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "costumers", ["company_id"], name: "index_costumers_on_company_id"
  add_index "costumers", ["user_id"], name: "index_costumers_on_user_id"

  create_table "depots", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "address"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "depots", ["company_id"], name: "index_depots_on_company_id"
  add_index "depots", ["user_id"], name: "index_depots_on_user_id"

  create_table "drivers", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "work_start_time"
    t.datetime "work_end_time"
    t.boolean  "activ"
    t.integer  "working_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "drivers", ["company_id"], name: "index_drivers_on_company_id"
  add_index "drivers", ["user_id"], name: "index_drivers_on_user_id"

  create_table "order_tours", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "tour_id"
    t.integer  "company_id"
    t.string   "location"
    t.integer  "place"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.integer  "capacity"
    t.integer  "capacity_status"
    t.integer  "time"
    t.integer  "duration"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "kind"
  end

  add_index "order_tours", ["company_id"], name: "index_order_tours_on_company_id"
  add_index "order_tours", ["order_id"], name: "index_order_tours_on_order_id"
  add_index "order_tours", ["tour_id"], name: "index_order_tours_on_tour_id"
  add_index "order_tours", ["user_id"], name: "index_order_tours_on_user_id"

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "costumer_id"
    t.integer  "company_id"
    t.string   "pickup_location"
    t.string   "delivery_location"
    t.integer  "capacity"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.integer  "duration_pickup"
    t.integer  "duration_delivery"
    t.string   "adress"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "activ"
  end

  add_index "orders", ["company_id"], name: "index_orders_on_company_id"
  add_index "orders", ["costumer_id"], name: "index_orders_on_costumer_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "restrictions", force: true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "problem"
    t.boolean  "dynamic"
    t.boolean  "multi_vehicle"
    t.boolean  "time_window"
    t.boolean  "capacity_restriction"
    t.boolean  "priorities"
    t.boolean  "work_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restrictions", ["company_id"], name: "index_restrictions_on_company_id"
  add_index "restrictions", ["user_id"], name: "index_restrictions_on_user_id"

  create_table "tours", force: true do |t|
    t.integer  "user_id"
    t.integer  "driver_id"
    t.integer  "company_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tours", ["company_id"], name: "index_tours_on_company_id"
  add_index "tours", ["driver_id"], name: "index_tours_on_driver_id"
  add_index "tours", ["user_id"], name: "index_tours_on_user_id"

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "vehicles", force: true do |t|
    t.integer  "user_id"
    t.string   "position"
    t.integer  "capacity"
    t.integer  "duration"
    t.integer  "driver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "vehicles", ["driver_id"], name: "index_vehicles_on_driver_id"
  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id"

end
