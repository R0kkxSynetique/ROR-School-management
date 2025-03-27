class Period < ApplicationRecord
  has_many :schedules, dependent: :nullify
  has_many :school_classes, dependent: :nullify

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  def period_display
    "#{start_date.strftime("%B %d, %Y")} - #{end_date.strftime("%B %d, %Y")}"
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
