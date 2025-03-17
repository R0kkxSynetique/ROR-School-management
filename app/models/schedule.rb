class Schedule < ApplicationRecord
  belongs_to :course, foreign_key: "courses_id"
  has_many :periods, dependent: :destroy
  has_many :school_classes, through: :periods

  enum :week_day, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :week_day, presence: true
  validates :course, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
