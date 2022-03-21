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

ActiveRecord::Schema.define(version: 20220304060223) do

  create_table "accounts", force: :cascade do |t|
    t.date "accounting_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "compound_journals", force: :cascade do |t|
    t.string "account_title"
    t.integer "amount"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tax_rate"
    t.string "description"
    t.string "sub_account_title"
    t.string "right_account_title"
    t.integer "right_tax_rate"
    t.string "right_sub_account_title"
    t.integer "right_amount"
    t.date "compound_accounting_date"
    t.index ["account_id"], name: "index_compound_journals_on_account_id"
  end

  create_table "grounds", force: :cascade do |t|
    t.string "fishing_ground_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "landings", force: :cascade do |t|
    t.string "weather"
    t.decimal "water_temperature", precision: 12, scale: 2
    t.string "fish_species"
    t.decimal "landing_amount", precision: 12, scale: 2
    t.date "landing_date"
    t.string "wind"
    t.string "wave"
    t.string "remarks"
    t.string "size_etc"
    t.integer "unit_price"
    t.string "purchase"
    t.string "shipping_destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ground_id"
    t.time "landing_time"
    t.string "landing_fishing_ground_name"
    t.index ["ground_id"], name: "index_landings_on_ground_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.boolean "accounting", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
