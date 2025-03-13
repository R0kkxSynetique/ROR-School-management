class Employee < Person
  has_many :examinations, foreign_key: "person_id"
  has_and_belongs_to_many :courses, join_table: "courses_people", foreign_key: "person_id"
  has_and_belongs_to_many :specializations, join_table: "people_specializations", foreign_key: "person_id"
  has_and_belongs_to_many :grades, join_table: "grades_people", foreign_key: "person_id"
  has_and_belongs_to_many :classes, join_table: "classes_people", foreign_key: "person_id"

  validates :iban, presence: true
end
