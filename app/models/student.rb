class Student < Person
  has_many :grades, foreign_key: "student_id"
  has_many :examinations, through: :grades
  has_and_belongs_to_many :school_classes, join_table: "school_classes_students"

  scope :active, -> { where(status: "active") }
  scope :archived, -> { where(status: "archived") }

  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :phone_number, presence: true
  validates :status, inclusion: { in: [ "active", "archived" ] }

  before_validation :set_default_status

  def archive!
    update(status: "archived")
  end

  def unarchive!
    update(status: "active")
  end

  private

  def set_default_status
    self.status ||= "active"
  end
end
