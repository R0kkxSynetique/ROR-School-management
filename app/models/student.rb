class Student < Person
  has_many :grades, foreign_key: "student_id"
  has_many :examinations, through: :grades
  has_and_belongs_to_many :school_classes, join_table: "school_classes_students"
end
