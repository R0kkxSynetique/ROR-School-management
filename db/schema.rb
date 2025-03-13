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

ActiveRecord::Schema[8.0].define(version: 2025_03_06_150004) do
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
    t.index ["uid"], name: "index_classes_on_uid", unique: true
  end

  create_table "classes_courses", id: false, force: :cascade do |t|
    t.integer "class_id", null: false
    t.integer "course_id", null: false
    t.index ["class_id", "course_id"], name: "index_classes_courses_on_class_id_and_course_id"
    t.index ["course_id", "class_id"], name: "index_classes_courses_on_course_id_and_class_id"
  end

  create_table "classes_people", id: false, force: :cascade do |t|
    t.integer "class_id", null: false
    t.integer "person_id", null: false
    t.index ["class_id", "person_id"], name: "index_classes_people_on_class_id_and_person_id"
    t.index ["person_id", "class_id"], name: "index_classes_people_on_person_id_and_class_id"
  end

  create_table "classes_students", id: false, force: :cascade do |t|
    t.integer "class_id", null: false
    t.integer "student_id", null: false
    t.index ["class_id", "student_id"], name: "index_classes_students_on_class_id_and_student_id"
    t.index ["student_id", "class_id"], name: "index_classes_students_on_student_id_and_class_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id", null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
    t.index ["room_id"], name: "index_courses_on_room_id"
  end

  create_table "courses_people", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "person_id", null: false
    t.index ["course_id", "person_id"], name: "index_courses_people_on_course_id_and_person_id"
    t.index ["person_id", "course_id"], name: "index_courses_people_on_person_id_and_course_id"
  end

  create_table "courses_specializations", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "specialization_id", null: false
    t.index ["course_id", "specialization_id"], name: "idx_on_course_id_specialization_id_9ad6bad3e3"
    t.index ["specialization_id", "course_id"], name: "idx_on_specialization_id_course_id_92771e638d"
  end

  create_table "examinations", force: :cascade do |t|
    t.string "title"
    t.date "expected_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id", null: false
    t.integer "course_id", null: false
    t.index ["course_id"], name: "index_examinations_on_course_id"
    t.index ["person_id"], name: "index_examinations_on_person_id"
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

  create_table "grades_people", id: false, force: :cascade do |t|
    t.integer "grade_id", null: false
    t.integer "person_id", null: false
    t.index ["grade_id", "person_id"], name: "index_grades_people_on_grade_id_and_person_id"
    t.index ["person_id", "grade_id"], name: "index_grades_people_on_person_id_and_grade_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "username"
    t.string "lastname"
    t.string "firstname"
    t.string "phone_number"
    t.string "status"
    t.string "type"
    t.string "iban"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "address_id", null: false
    t.integer "user_id"
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["user_id"], name: "index_people_on_user_id"
    t.index ["username"], name: "index_people_on_username", unique: true
  end

  create_table "people_specializations", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "specialization_id", null: false
    t.index ["person_id", "specialization_id"], name: "idx_on_person_id_specialization_id_a6dd17b116"
    t.index ["specialization_id", "person_id"], name: "idx_on_specialization_id_person_id_768825ca21"
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
    t.index ["promotion_asserment_id", "section_id"], name: "idx_promotions_sections"
    t.index ["section_id", "promotion_asserment_id"], name: "idx_sections_promotions"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rooms_on_name", unique: true
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
    t.index ["name"], name: "index_specializations_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "classes", "sections"
  add_foreign_key "courses", "rooms"
  add_foreign_key "examinations", "courses"
  add_foreign_key "examinations", "people"
  add_foreign_key "grades", "examinations"
  add_foreign_key "grades", "people", column: "student_id"
  add_foreign_key "people", "addresses"
  add_foreign_key "people", "users"
  add_foreign_key "periods", "classes", column: "classes_id"
  add_foreign_key "periods", "schedules"
  add_foreign_key "schedules", "courses", column: "courses_id"
  add_foreign_key "users", "people"
end
