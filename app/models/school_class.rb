class SchoolClass < ApplicationRecord
  belongs_to :section
  has_and_belongs_to_many :courses, join_table: "courses_school_classes", foreign_key: "school_class_id", association_foreign_key: "course_id"
  has_many :periods, dependent: :destroy, foreign_key: "school_class_id"
  has_and_belongs_to_many :teachers, class_name: "Employee", join_table: "people_school_classes", foreign_key: "school_class_id", association_foreign_key: "person_id"
  has_and_belongs_to_many :students, join_table: "school_classes_students"

  validates :name, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :section, presence: true

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def archive!
    update(archived: true, archived_at: Time.current)
  end

  def unarchive!
    update(archived: false, archived_at: nil)
  end
end
