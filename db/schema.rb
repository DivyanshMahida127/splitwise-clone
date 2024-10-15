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

ActiveRecord::Schema.define(version: 2024_10_02_023633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.bigint "created_by_id", null: false
    t.bigint "paid_by_id", null: false
    t.string "title"
    t.text "description"
    t.date "date", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_expenses_on_created_by_id"
    t.index ["paid_by_id"], name: "index_expenses_on_paid_by_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "payer_id", null: false
    t.bigint "payee_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payee_id"], name: "index_payments_on_payee_id"
    t.index ["payer_id"], name: "index_payments_on_payer_id"
  end

  create_table "user_expenses", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_user_expenses_on_expense_id"
    t.index ["user_id"], name: "index_user_expenses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "mobile_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "expenses", "users", column: "created_by_id"
  add_foreign_key "expenses", "users", column: "paid_by_id"
  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "user_expenses", "expenses"
  add_foreign_key "user_expenses", "users"
end
