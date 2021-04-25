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

ActiveRecord::Schema.define(version: 2021_04_20_080525) do

  create_table "payment_sources", force: :cascade do |t|
    t.integer "rider_id"
    t.integer "source_id"
    t.string "brand"
    t.string "name"
    t.integer "last_four"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rider_id"], name: "index_payment_sources_on_rider_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "trip_id"
    t.integer "payment_source_id"
    t.integer "status", default: 0
    t.string "reference"
    t.string "transaction_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_source_id"], name: "index_transactions_on_payment_source_id"
    t.index ["trip_id"], name: "index_transactions_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.integer "rider_id"
    t.integer "driver_id"
    t.string "origin"
    t.string "destination"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["rider_id"], name: "index_trips_on_rider_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
