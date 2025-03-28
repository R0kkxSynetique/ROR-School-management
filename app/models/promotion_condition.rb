class PromotionCondition < ApplicationRecord
  belongs_to :promotion_asserment
  has_and_belongs_to_many :courses, join_table: "courses_promotion_conditions"

  validates :condition_type, presence: true, inclusion: { in: %w[single_course multiple_courses overall_average] }
  validates :minimum_grade, presence: true, numericality: { greater_than_or_equal_to: 1.0, less_than_or_equal_to: 6.0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :courses, presence: true, unless: -> { condition_type == "overall_average" }

  def evaluate_student(student)
    case condition_type
    when "single_course"
      evaluate_single_course(student)
    when "multiple_courses"
      evaluate_multiple_courses(student)
    when "overall_average"
      evaluate_overall_average(student)
    end
  end

  private

  def evaluate_single_course(student)
    return false unless courses.count == 1
    course = courses.first
    average_grade = student.grades.joins(:examination)
                          .where(examinations: { course_id: course.id })
                          .average(:value)
    average_grade.to_f >= minimum_grade
  end

  def evaluate_multiple_courses(student)
    return false if courses.empty?

    course_averages = courses.map do |course|
      student.grades.joins(:examination)
             .where(examinations: { course_id: course.id })
             .average(:value).to_f
    end

    course_averages.all? { |avg| avg >= minimum_grade }
  end

  def evaluate_overall_average(student)
    overall_average = student.grades.average(:value).to_f
    overall_average >= minimum_grade
  end
end
