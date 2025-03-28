class Employee < Person
  has_many :examinations, foreign_key: "person_id"
  has_and_belongs_to_many :courses, join_table: "courses_people", foreign_key: "person_id"
  has_and_belongs_to_many :specializations, join_table: "people_specializations", foreign_key: "person_id"
  has_and_belongs_to_many :grades, join_table: "grades_people", foreign_key: "person_id"
  has_and_belongs_to_many :teaching_classes, class_name: "SchoolClass", join_table: "people_school_classes", foreign_key: "person_id"
  validates :iban, presence: true

  scope :active, -> { where(status: "active") }
  scope :archived, -> { where(status: "archived") }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= "active"
  end
end
