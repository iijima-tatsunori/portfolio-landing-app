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

ActiveRecord::Schema.define(version: 20201201044154) do

  create_table "accounts", force: :cascade do |t|
    t.date "accounting_date"
    t.string "account_title"
    t.string "description"
    t.integer "income"
    t.integer "expense"
    t.integer "deduction_balance"
    t.integer "tax_rate"
    t.integer "subsidiary_journal_species"
    t.string "check_number"
    t.integer "deposit"
    t.integer "drawer"
    t.integer "debit_credit"
    t.integer "balance"
    t.string "customer"
    t.string "receiving_method"
    t.string "product_name"
    t.decimal "quantity"
    t.integer "unit_price"
    t.integer "breakdown"
    t.integer "amount"
    t.integer "general_edger_number"
    t.integer "journal_books_number"
    t.string "notation"
    t.string "debit_account"
    t.string "credit_account"
    t.integer "debit_amount"
    t.integer "credit_amount"
    t.integer "journal_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "journal_description"
  end

  create_table "grounds", force: :cascade do |t|
    t.string "fishing_ground_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "landings", force: :cascade do |t|
    t.string "weather"
    t.decimal "water_temperature"
    t.string "fish_species"
    t.decimal "landing_amount"
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
