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

ActiveRecord::Schema[8.1].define(version: 2026_05_21_065830) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bids", force: :cascade do |t|
    t.integer "amount"
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.bigint "draft_round_id", null: false
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["character_id"], name: "index_bids_on_character_id"
    t.index ["draft_round_id"], name: "index_bids_on_draft_round_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "characters", force: :cascade do |t|
    t.integer "base_cost"
    t.datetime "created_at", null: false
    t.integer "defense"
    t.integer "dunk"
    t.integer "intelligence"
    t.string "name"
    t.string "recommanded_position"
    t.integer "shoot"
    t.integer "speed"
    t.integer "strength"
    t.string "universe"
    t.datetime "updated_at", null: false
  end

  create_table "draft_results", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.bigint "draft_round_id", null: false
    t.boolean "tie_broken_by_time"
    t.datetime "updated_at", null: false
    t.bigint "winner_id", null: false
    t.integer "winning_amount"
    t.index ["character_id"], name: "index_draft_results_on_character_id"
    t.index ["draft_round_id"], name: "index_draft_results_on_draft_round_id"
    t.index ["winner_id"], name: "index_draft_results_on_winner_id"
  end

  create_table "draft_rounds", force: :cascade do |t|
    t.datetime "away_validate_at"
    t.datetime "created_at", null: false
    t.bigint "duel_id", null: false
    t.datetime "home_validate_at"
    t.integer "round_number"
    t.datetime "updated_at", null: false
    t.index ["duel_id"], name: "index_draft_rounds_on_duel_id"
  end

  create_table "duels", force: :cascade do |t|
    t.bigint "away_user_id", null: false
    t.integer "budget"
    t.datetime "created_at", null: false
    t.integer "current_round"
    t.bigint "home_user_id", null: false
    t.string "origin"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["away_user_id"], name: "index_duels_on_away_user_id"
    t.index ["home_user_id"], name: "index_duels_on_home_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.bigint "sender_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.index ["sender_id"], name: "index_friendships_on_sender_id"
  end

  create_table "match_player_stats", force: :cascade do |t|
    t.integer "assists"
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "interceptions"
    t.bigint "match_id", null: false
    t.integer "points"
    t.string "position"
    t.integer "rebounds"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["character_id"], name: "index_match_player_stats_on_character_id"
    t.index ["match_id"], name: "index_match_player_stats_on_match_id"
    t.index ["user_id"], name: "index_match_player_stats_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "away_score"
    t.datetime "created_at", null: false
    t.bigint "duel_id", null: false
    t.integer "home_score"
    t.text "narrative"
    t.datetime "played_at"
    t.integer "q1_away"
    t.integer "q1_home"
    t.integer "q2_away"
    t.integer "q2_home"
    t.integer "q3_away"
    t.integer "q3_home"
    t.integer "q4_away"
    t.integer "q4_home"
    t.datetime "updated_at", null: false
    t.bigint "winner_id"
    t.index ["duel_id"], name: "index_matches_on_duel_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bids", "characters"
  add_foreign_key "bids", "draft_rounds"
  add_foreign_key "bids", "users"
  add_foreign_key "draft_results", "characters"
  add_foreign_key "draft_results", "draft_rounds"
  add_foreign_key "draft_results", "users", column: "winner_id"
  add_foreign_key "draft_rounds", "duels"
  add_foreign_key "duels", "users", column: "away_user_id"
  add_foreign_key "duels", "users", column: "home_user_id"
  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "friendships", "users", column: "sender_id"
  add_foreign_key "match_player_stats", "characters"
  add_foreign_key "match_player_stats", "matches"
  add_foreign_key "match_player_stats", "users"
  add_foreign_key "matches", "duels"
  add_foreign_key "matches", "users", column: "winner_id"
end
