class PromotionAsserment < ApplicationRecord
  has_and_belongs_to_many :sections

  VALID_OPERATORS = [ "<", ">", "<=", ">=", "=" ].freeze
  VARIABLES = {
    "course" => "Single course grade",
    "courses_average" => "Average grade of multiple courses",
    "overall_average" => "Overall student grade average"
  }.freeze

  validates :effective_date, presence: true
  validates :condition_variable, inclusion: { in: VARIABLES.keys }
  validates :condition_operator, inclusion: { in: VALID_OPERATORS }
  validates :condition_value, presence: true, numericality: true
  validates :course_ids, presence: true, if: :requires_courses?

  serialize :course_ids, type: Array, coder: JSON

  private

  def requires_courses?
    [ "course", "courses_average" ].include?(condition_variable)
  end

  def evaluate_for_student(student)
    case condition_variable
    when "course"
      evaluate_single_course(student)
    when "courses_average"
      evaluate_courses_average(student)
    when "overall_average"
      evaluate_overall_average(student)
    end
  end

  def evaluate_single_course(student)
    return false if course_ids.blank?

    grade = student.grades.where(course_id: course_ids.first).average(:value)
    return false unless grade

    compare_values(grade, condition_value)
  end

  def evaluate_courses_average(student)
    return false if course_ids.blank?

    grade = student.grades.where(course_id: course_ids).average(:value)
    return false unless grade

    compare_values(grade, condition_value)
  end

  def evaluate_overall_average(student)
    grade = student.grades.average(:value)
    return false unless grade

    compare_values(grade, condition_value)
  end

  def compare_values(actual, expected)
    case condition_operator
    when "<" then actual < expected
    when ">" then actual > expected
    when "<=" then actual <= expected
    when ">=" then actual >= expected
    when "=" then actual == expected
    end
  end
end
