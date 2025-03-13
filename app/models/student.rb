class Student < Person
  has_many :grades, foreign_key: "student_id"
  has_many :examinations, through: :grades
end
