class Grade < ApplicationRecord
  belongs_to :examination
  belongs_to :student, class_name: "Student", foreign_key: "student_id"
  has_and_belongs_to_many :teachers, class_name: "Employee", join_table: "grades_people", foreign_key: "grade_id", association_foreign_key: "person_id"

  validates :value, presence: true,
                   numericality: {
                     greater_than_or_equal_to: 0,
                     less_than_or_equal_to: 6,
                     decimal: true
                   }

  before_validation :round_to_one_decimal

  private

  def round_to_one_decimal
    self.value = value.round(1) if value.present?
  end
end
