ActiveRecord::Schema[7.1].define(version: 2024_04_22_183525) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "merchant_id", null: false
    t.string "value_type"
    t.integer "value_off"
    t.boolean "active"
    t.integer "usage_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
    t.index ["merchant_id"], name: "index_coupons_on_merchant_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity"
    t.integer "unit_price"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["item_id"], name: "index_invoice_items_on_item_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "status"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "coupon_id"
    t.index ["coupon_id"], name: "index_invoices_on_coupon_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "unit_price"
    t.bigint "merchant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
  end

  create_table "transactions", force: :cascade do |t|
    t.string "credit_card_number"
    t.string "credit_card_expiration_date"
    t.integer "result"
    t.bigint "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
  end

  add_foreign_key "coupons", "merchants"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "items"
  add_foreign_key "invoices", "coupons"
  add_foreign_key "invoices", "customers"
  add_foreign_key "items", "merchants"
  add_foreign_key "transactions", "invoices"
end
