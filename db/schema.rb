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

ActiveRecord::Schema.define(version: 20200318101600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.integer "local_code"
    t.string "market_division"
    t.integer "tsi_code"
    t.string "topix_sector_indices"
    t.integer "t17_code"
    t.string "topix_17"
    t.integer "sc_code"
    t.string "size_classification"
    t.integer "pub_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
  end

  create_table "watchlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "local_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["local_code"], name: "index_watchlists_on_local_code"
    t.index ["user_id", "local_code"], name: "index_watchlists_on_user_id_and_local_code", unique: true
    t.index ["user_id"], name: "index_watchlists_on_user_id"
  end

end
