class PromotionAsserment < ApplicationRecord
  has_and_belongs_to_many :sections
  belongs_to :dean
  has_many :promotion_conditions, dependent: :destroy

  accepts_nested_attributes_for :promotion_conditions, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :effective_date, presence: true
  validate :single_condition

  def evaluate_student(student)
    return false unless student.is_a?(Student)

    required_conditions_met = promotion_conditions.where(required: true).all? do |condition|
      condition.evaluate_student(student)
    end

    return false unless required_conditions_met

    # For optional conditions, we calculate a weighted average
    optional_conditions = promotion_conditions.where(required: false)
    return true if optional_conditions.empty?

    total_weight = optional_conditions.sum(&:weight)
    weighted_sum = optional_conditions.sum do |condition|
      condition.evaluate_student(student) ? condition.weight : 0
    end

    (weighted_sum / total_weight) >= 0.5
  end

  private

  def single_condition
    if promotion_conditions.reject(&:marked_for_destruction?).size > 1
      errors.add(:base, "Only one condition is allowed per promotion assessment")
    end
  end
end
