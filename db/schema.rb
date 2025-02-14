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

ActiveRecord::Schema[8.0].define(version: 2025_02_14_121347) do
  create_table "addresses", force: :cascade do |t|
    t.string "address"
    t.string "locality"
    t.string "postal_code"
    t.string "administrative_area"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classes", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id", null: false
    t.index ["section_id"], name: "index_classes_on_section_id"
  end

  create_table "classes_courses", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "class_id", null: false
  end

  create_table "classes_employees", id: false, force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "class_id", null: false
  end

  create_table "classes_students", id: false, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "class_id", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id", null: false
    t.index ["room_id"], name: "index_courses_on_room_id"
  end

  create_table "courses_employees", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "employee_id", null: false
  end

  create_table "courses_specializations", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "specialization_id", null: false
  end

  create_table "employees_grades", id: false, force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "grade_id", null: false
  end

  create_table "employees_specializations", id: false, force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "specialization_id", null: false
  end

  create_table "examinations", force: :cascade do |t|
    t.string "title"
    t.date "expected_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id", null: false
    t.integer "course_id", null: false
    t.index ["course_id"], name: "index_examinations_on_course_id"
    t.index ["employee_id"], name: "index_examinations_on_employee_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "value"
    t.date "effective_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "examination_id", null: false
    t.integer "student_id", null: false
    t.index ["examination_id"], name: "index_grades_on_examination_id"
    t.index ["student_id"], name: "index_grades_on_student_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "username"
    t.string "lastname"
    t.string "firstname"
    t.string "email"
    t.string "phone_number"
    t.string "status"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "address_id", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
  end

  create_table "periods", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule_id", null: false
    t.integer "classes_id", null: false
    t.index ["classes_id"], name: "index_periods_on_classes_id"
    t.index ["schedule_id"], name: "index_periods_on_schedule_id"
  end

  create_table "promotion_asserments", force: :cascade do |t|
    t.date "effective_date"
    t.string "condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotion_asserments_sections", id: false, force: :cascade do |t|
    t.integer "section_id", null: false
    t.integer "promotion_asserment_id", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.integer "week_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "courses_id", null: false
    t.index ["courses_id"], name: "index_schedules_on_courses_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "classes", "sections"
  add_foreign_key "courses", "rooms"
  add_foreign_key "examinations", "courses"
  add_foreign_key "examinations", "people", column: "employee_id"
  add_foreign_key "grades", "examinations"
  add_foreign_key "grades", "people", column: "student_id"
  add_foreign_key "people", "addresses"
  add_foreign_key "periods", "classes", column: "classes_id"
  add_foreign_key "periods", "schedules"
  add_foreign_key "schedules", "courses", column: "courses_id"
end
