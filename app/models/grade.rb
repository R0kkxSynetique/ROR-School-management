class Grade < ApplicationRecord
  belongs_to :examination
  belongs_to :student, class_name: "Student", foreign_key: "student_id"
  has_and_belongs_to_many :teachers, class_name: "Employee", join_table: "grades_people", foreign_key: "grade_id", association_foreign_key: "person_id"
end
