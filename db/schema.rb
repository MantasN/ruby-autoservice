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

ActiveRecord::Schema.define(version: 20161122151237) do

  create_table "details", force: :cascade do |t|
    t.string   "reason"
    t.string   "car"
    t.string   "owner"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_details_on_order_id", unique: true
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price"
    t.integer  "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_jobs_on_report_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date     "date"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string   "title"
    t.integer  "quantity"
    t.decimal  "prime_price"
    t.decimal  "client_price"
    t.integer  "report_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["report_id"], name: "index_parts_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "comment"
    t.integer  "order_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "car_mileage"
    t.boolean  "hide_prime"
    t.index ["order_id"], name: "index_reports_on_order_id", unique: true
  end

end
