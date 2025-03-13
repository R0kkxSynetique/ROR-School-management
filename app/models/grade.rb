class Grade < ApplicationRecord
  belongs_to :examination
  belongs_to :student, class_name: "Student", foreign_key: "student_id"
end
