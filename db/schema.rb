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

ActiveRecord::Schema.define(version: 2021_11_02_111245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "options", force: :cascade do |t|
    t.string "option1"
    t.string "option2"
    t.string "option3"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "question_similar_words", force: :cascade do |t|
    t.integer "question_id"
    t.string "similar_word"
  end

  create_table "question_tags", force: :cascade do |t|
    t.integer "question_id"
    t.integer "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "option1"
    t.string "option2"
    t.string "option3"
    t.string "result"
    t.integer "answer"
    t.integer "user_answer"
  end

  create_table "similars", force: :cascade do |t|
    t.string "name"
    t.integer "word_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tag_words", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_tag_words_on_tag_id"
    t.index ["word_id"], name: "index_tag_words_on_word_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "highest_rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.integer "correct_number"
    t.integer "false_number"
  end

  create_table "wordbooks", force: :cascade do |t|
    t.integer "q1_id"
    t.integer "q2_id"
    t.integer "q3_id"
    t.integer "q4_id"
    t.integer "q5_id"
    t.integer "q6_id"
    t.integer "q7_id"
    t.integer "q8_id"
    t.integer "q9_id"
    t.integer "q10_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "finish_number"
    t.integer "finish_id"
    t.integer "user_id"
    t.integer "correct_number"
  end

  create_table "words", force: :cascade do |t|
    t.string "name"
    t.string "meaning"
    t.string "image_name"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "tag_words", "tags"
  add_foreign_key "tag_words", "words"
end
