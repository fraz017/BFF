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

ActiveRecord::Schema.define(version: 20171018065641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_categories_on_message_id", using: :btree
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chat_rooms_on_user_id", using: :btree
  end

  create_table "chat_rooms_messages", id: false, force: :cascade do |t|
    t.integer "chat_room_id"
    t.integer "message_id"
    t.index ["chat_room_id", "message_id"], name: "index_chat_rooms_messages_on_chat_room_id_and_message_id", using: :btree
    t.index ["message_id", "chat_room_id"], name: "index_chat_rooms_messages_on_message_id_and_chat_room_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "rating"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.integer  "reply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_likes_on_message_id", using: :btree
    t.index ["reply_id"], name: "index_likes_on_reply_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.string   "log_type"
    t.integer  "sender_id"
    t.integer  "message_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matchers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "matched_with"
    t.float    "profile_score"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_matchers_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "flagged"
    t.boolean  "visible",    default: true
  end

  create_table "replies", force: :cascade do |t|
    t.integer  "message_id"
    t.text     "content"
    t.integer  "sender_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "score",      default: 0
    t.boolean  "visible",    default: true
    t.integer  "flagged"
    t.index ["message_id"], name: "index_replies_on_message_id", using: :btree
  end

  create_table "reported_messages", force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "reported_by"
    t.integer  "reply_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "title"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "chat_with"
    t.index ["user_id"], name: "index_rooms_on_user_id", using: :btree
  end

  create_table "single_messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_single_messages_on_room_id", using: :btree
    t.index ["user_id"], name: "index_single_messages_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "gender"
    t.string   "age_range"
    t.string   "education"
    t.string   "location"
    t.string   "college"
    t.boolean  "complete_profile",       default: false
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "country_code"
    t.string   "coordinates"
    t.string   "area"
    t.integer  "role_cd",                default: 1
    t.boolean  "is_online",              default: false
    t.integer  "score",                  default: 0
    t.integer  "flagged"
    t.integer  "loyalty_score",          default: 0
    t.integer  "messaging_score",        default: 0
    t.boolean  "blocked",                default: false
    t.float    "average_score"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "date_of_birth"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "chat_rooms", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "replies", "messages"
  add_foreign_key "rooms", "users"
  add_foreign_key "single_messages", "rooms"
  add_foreign_key "single_messages", "users"
end
