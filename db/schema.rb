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

ActiveRecord::Schema[7.1].define(version: 2023_11_02_194834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disbursements", force: :cascade do |t|
    t.decimal "net_amount", precision: 10, scale: 2
    t.decimal "collected_fee", precision: 10, scale: 2
    t.bigint "merchant_id", null: false
    t.string "reference"
    t.datetime "created_at"
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "reference"
    t.string "email"
    t.datetime "live_on"
    t.string "disbursement_frequency"
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2
    t.index ["reference"], name: "index_merchants_on_reference"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "merchant_id", null: false
    t.string "merchant_reference"
    t.boolean "disbursed", default: false
    t.integer "disbursement_id"
    t.decimal "collected_fee", precision: 10, scale: 2
    t.decimal "disbursed_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  create_table "remaining_monthly_fees", force: :cascade do |t|
    t.integer "merchant_id"
    t.decimal "fee", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "orders", "merchants"
end
