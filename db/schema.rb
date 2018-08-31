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

ActiveRecord::Schema.define(version: 20180831095344) do

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "time_start"
    t.datetime "time_end"
    t.integer "mis_amount"
    t.decimal "total_btc", precision: 18, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mis_sell"
  end

  create_table "fixed_campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.decimal "start_btc", precision: 18, scale: 8
    t.decimal "end_btc", precision: 18, scale: 8
    t.decimal "btc_to_mis", precision: 18, scale: 8
    t.decimal "current_btc", precision: 18, scale: 8, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "kyc_address_id"
    t.bigint "fixed_campaign_id"
    t.bigint "transaction_id"
    t.decimal "value", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "overload", default: false
    t.index ["fixed_campaign_id"], name: "index_histories_on_fixed_campaign_id"
    t.index ["kyc_address_id"], name: "index_histories_on_kyc_address_id"
    t.index ["transaction_id"], name: "index_histories_on_transaction_id"
  end

  create_table "kyc_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "address"
    t.string "mis_amount"
    t.string "btc_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mis_address"
    t.string "email"
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "min_confirmation"
    t.boolean "require_confirmation", default: true
    t.decimal "current_rate", precision: 18, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "max_btc", precision: 10, default: "10"
  end

  create_table "stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "count", default: 1
    t.integer "last", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "value", precision: 18, scale: 8
    t.string "txid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kyc_address_id"
    t.datetime "tx_created_at"
    t.integer "height"
    t.index ["kyc_address_id"], name: "index_transactions_on_kyc_address_id"
  end

  add_foreign_key "transactions", "kyc_addresses"
end
