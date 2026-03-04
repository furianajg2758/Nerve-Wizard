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

ActiveRecord::Schema[8.1].define(version: 2026_03_01_222511) do
  create_table "concerns", force: :cascade do |t|
    t.string "affected_areas"
    t.datetime "created_at", null: false
    t.string "nerve_type"
    t.text "paresthesia"
    t.text "reflexes"
    t.text "sensory"
    t.text "symptoms"
    t.datetime "updated_at", null: false
    t.text "weakness"
  end

  create_table "nerve_references", force: :cascade do |t|
    t.text "affected_areas"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "nerve_type"
    t.text "paresthesia"
    t.text "reflexes"
    t.text "sensory"
    t.datetime "updated_at", null: false
    t.text "weakness"
  end
end
