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

ActiveRecord::Schema[7.0].define(version: 2022_02_17_084100) do
  create_table "companies", primary_key: "code", id: { type: :string, limit: 8 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sector", null: false
    t.string "currency_code", limit: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pricing_settings_count", default: 0, null: false
    t.index ["currency_code"], name: "fk_rails_d28d8fc67b"
  end

  create_table "countries", primary_key: "code", id: { type: :string, limit: 4 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", primary_key: "code", id: { type: :string, limit: 4 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", primary_key: "code", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "_type", null: false
    t.bigint "minimum_amount"
    t.bigint "maximum_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["_type"], name: "index_payment_methods_on__type"
  end

  create_table "payment_options", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "currency_code", limit: 4, null: false
    t.string "payment_method_code", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_code"], name: "fk_rails_39a5b97340"
    t.index ["payment_method_code"], name: "fk_rails_0316c24f3f"
  end

  create_table "pricing_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company_code", limit: 8, null: false
    t.string "country_code", limit: 4, null: false
    t.decimal "spread_unit_rate", precision: 6, scale: 5, null: false
    t.json "fee", null: false
    t.bigint "payment_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_code"], name: "fk_rails_c931f04645"
    t.index ["country_code"], name: "fk_rails_2c0a765b8a"
    t.index ["payment_option_id"], name: "index_pricing_settings_on_payment_option_id"
  end

  add_foreign_key "companies", "currencies", column: "currency_code", primary_key: "code"
  add_foreign_key "payment_options", "currencies", column: "currency_code", primary_key: "code"
  add_foreign_key "payment_options", "payment_methods", column: "payment_method_code", primary_key: "code"
  add_foreign_key "pricing_settings", "companies", column: "company_code", primary_key: "code"
  add_foreign_key "pricing_settings", "countries", column: "country_code", primary_key: "code"
  add_foreign_key "pricing_settings", "payment_options"
end
