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

ActiveRecord::Schema.define(version: 2020_02_07_210635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "fixture_id"
    t.bigint "eventtype_id"
    t.string "minute"
    t.bigint "player_id"
    t.bigint "team_id"
    t.bigint "other_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eventtype_id"], name: "index_events_on_eventtype_id"
    t.index ["fixture_id"], name: "index_events_on_fixture_id"
    t.index ["other_player_id"], name: "index_events_on_other_player_id"
    t.index ["player_id"], name: "index_events_on_player_id"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "eventtypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixtures", force: :cascade do |t|
    t.string "status"
    t.date "date"
    t.time "time"
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.integer "scorehome"
    t.integer "scoreaway"
    t.integer "stage"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_fixtures_on_away_team_id"
    t.index ["home_team_id"], name: "index_fixtures_on_home_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "nationality"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "ranks", force: :cascade do |t|
    t.bigint "fixture_id"
    t.bigint "team_id"
    t.float "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fixture_id"], name: "index_ranks_on_fixture_id"
    t.index ["team_id"], name: "index_ranks_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "city"
    t.string "light_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "eventtypes"
  add_foreign_key "events", "fixtures"
  add_foreign_key "events", "teams"
  add_foreign_key "players", "teams"
  add_foreign_key "ranks", "fixtures", on_delete: :cascade
  add_foreign_key "ranks", "teams"
end
