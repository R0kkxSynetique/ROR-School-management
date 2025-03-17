class Specialization < ApplicationRecord
  has_and_belongs_to_many :people, join_table: "people_specializations"
  has_and_belongs_to_many :courses, join_table: "courses_specializations"

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :archived, inclusion: { in: [ true, false ] }

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
end
