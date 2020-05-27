# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_26_193529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "postcode", default: "", null: false
    t.string "name", default: "", null: false
    t.string "country_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delivery_options", force: :cascade do |t|
    t.integer "code", null: false
    t.string "option", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "stock_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id", "stock_id"], name: "index_line_items_on_cart_id_and_stock_id", unique: true
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["stock_id"], name: "index_line_items_on_stock_id"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.decimal "unit_price", default: "0.0", null: false
    t.integer "quantity", default: 0, null: false
    t.integer "shop_id", null: false
    t.integer "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
    t.index ["shop_id"], name: "index_order_line_items_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "delivery_option_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.boolean "with_outside_shop_coverage_fee", default: false, null: false
    t.decimal "outside_shop_coverage_fee", default: "0.0", null: false
    t.integer "status_id", default: 0, null: false
    t.boolean "ocd_fee_accepted", default: false, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.integer "code", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "reference", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "product_category_id", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "code", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shop_delivery_coverages", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "city_postcode", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_postcode"], name: "index_shop_delivery_coverages_on_city_postcode"
    t.index ["shop_id", "city_postcode"], name: "index_shop_delivery_coverages_on_shop_id_and_city_postcode", unique: true
    t.index ["shop_id"], name: "index_shop_delivery_coverages_on_shop_id"
  end

  create_table "shop_delivery_options", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.integer "delivery_option_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["delivery_option_code"], name: "index_shop_delivery_options_on_delivery_option_code"
    t.index ["shop_id", "delivery_option_code"], name: "index_shop_delivery_options_on_shop_id_and_delivery_option_code"
    t.index ["shop_id"], name: "index_shop_delivery_options_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "product_category_code", null: false
    t.string "country_code", null: false
    t.string "phone_number", default: "", null: false
    t.string "street", default: "", null: false
    t.string "additional_address_information", default: ""
    t.string "city_postcode", null: false
    t.index ["city_postcode"], name: "index_shops_on_city_postcode"
    t.index ["country_code"], name: "index_shops_on_country_code"
    t.index ["product_category_code"], name: "index_shops_on_product_category_code"
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "product_reference", default: "", null: false
    t.decimal "price", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_reference", "shop_id"], name: "index_stocks_on_product_reference_and_shop_id", unique: true
    t.index ["product_reference"], name: "index_stocks_on_product_reference"
    t.index ["shop_id"], name: "index_stocks_on_shop_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", default: "", null: false
    t.string "firstname", default: "", null: false
    t.string "lastname", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "street", default: "", null: false
    t.string "additional_address_information", default: ""
    t.boolean "is_partner", default: false, null: false
    t.integer "role_code", default: 3, null: false
    t.string "country_code", default: "", null: false
    t.string "city_postcode", default: "", null: false
    t.index ["city_postcode"], name: "index_users_on_city_postcode"
    t.index ["country_code"], name: "index_users_on_country_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_code"], name: "index_users_on_role_code"
  end

end
