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

ActiveRecord::Schema.define(version: 20171013082152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "appointment_id"
    t.string "message", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "", null: false
    t.index ["appointment_id"], name: "index_activities_on_appointment_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "slot_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "memorable_word", null: false
    t.string "type_of_appointment", null: false
    t.date "date_of_birth", null: false
    t.integer "status", default: 0, null: false
    t.boolean "opt_out_of_market_research", default: false, null: false
    t.boolean "dc_pot_confirmed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "reminder_sent_at"
    t.index ["slot_id"], name: "index_appointments_on_slot_id", unique: true
  end

  create_table "delivery_centres", force: :cascade do |t|
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "reply_to", default: "", null: false
    t.index ["location_id"], name: "index_delivery_centres_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "address_line_one", default: "", null: false
    t.string "address_line_two", default: "", null: false
    t.string "address_line_three", default: "", null: false
    t.string "town", default: "", null: false
    t.string "county", default: "", null: false
    t.string "postcode", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_rooms_on_location_id"
  end

  create_table "slots", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_centre_id"
    t.index ["delivery_centre_id"], name: "index_slots_on_delivery_centre_id"
    t.index ["room_id"], name: "index_slots_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "uid"
    t.string "organisation_slug"
    t.string "organisation_content_id"
    t.string "permissions"
    t.boolean "remotely_signed_out", default: false
    t.boolean "disabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_centre_id"
    t.index ["delivery_centre_id"], name: "index_users_on_delivery_centre_id"
  end

  add_foreign_key "activities", "appointments"
  add_foreign_key "activities", "users"
  add_foreign_key "appointments", "slots"
  add_foreign_key "delivery_centres", "locations"
  add_foreign_key "slots", "delivery_centres"
  add_foreign_key "slots", "rooms"
  add_foreign_key "users", "delivery_centres"
end
