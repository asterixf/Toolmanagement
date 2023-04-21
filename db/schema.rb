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

ActiveRecord::Schema[7.0].define(version: 2023_04_21_022445) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blockages", force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.string "reason"
    t.string "created_by"
    t.string "last_updated_by"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tool_id"], name: "index_blockages_on_tool_id"
  end

  create_table "cavities", force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.string "created_by"
    t.string "last_updated_by"
    t.integer "num"
    t.string "status"
    t.boolean "is_spare", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tool_id"], name: "index_cavities_on_tool_id"
  end

  create_table "production_orders", force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.string "created_by"
    t.text "cavities_in_tool"
    t.text "comments"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_updated_by"
    t.index ["tool_id"], name: "index_production_orders_on_tool_id"
  end

  create_table "tools", force: :cascade do |t|
    t.string "alias"
    t.string "sap"
    t.string "plant"
    t.string "bu"
    t.string "technology"
    t.string "customer"
    t.bigint "volume"
    t.integer "capacity"
    t.integer "damaged"
    t.integer "blocked"
    t.integer "spares"
    t.integer "active"
    t.string "segment"
    t.float "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_updated_by"
    t.string "location"
    t.string "created_by"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "plant", null: false
    t.string "department", null: false
    t.string "position", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wash_orders", force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.string "created_by"
    t.string "tool_alias"
    t.integer "qty"
    t.text "comments"
    t.string "status"
    t.string "closed_by"
    t.time "washing_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tool_id"], name: "index_wash_orders_on_tool_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blockages", "tools"
  add_foreign_key "cavities", "tools"
  add_foreign_key "production_orders", "tools"
end
