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

ActiveRecord::Schema[7.0].define(version: 2022_07_26_114043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "user_handle"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
  end

  create_table "bills", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "expense_id", null: false
    t.integer "amount"
    t.string "status"
    t.string "attachments"
    t.decimal "invoice_number" #string 
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_bills_on_employee_id"
    t.index ["expense_id"], name: "index_bills_on_expense_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "user"
    t.string "description"
    t.string "user_email"
    t.bigint "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_comments_on_expense_id"
  end

  create_table "currents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "user_handle"
    t.string "email"
    t.boolean "terminated"
    t.decimal "phone_no"
    t.string "gender"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_employees_on_admin_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.integer "amount_claimed"
    t.integer "amount_approved"
    t.string "title"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
  end

  add_foreign_key "bills", "employees"
  add_foreign_key "bills", "expenses"
  add_foreign_key "comments", "expenses"
  add_foreign_key "employees", "admins"
  add_foreign_key "expenses", "employees"
end
