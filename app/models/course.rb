class Course < ApplicationRecord
  belongs_to :room
  has_many :examinations, dependent: :destroy
  has_many :schedules, dependent: :destroy, foreign_key: "courses_id"
  has_and_belongs_to_many :school_classes, class_name: "SchoolClass", join_table: "courses_school_classes", foreign_key: "course_id", association_foreign_key: "school_class_id"
  has_and_belongs_to_many :people, join_table: "courses_people"
end
