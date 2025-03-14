class Person < ApplicationRecord
  belongs_to :address
  belongs_to :user, optional: true

  validates :username, presence: true, uniqueness: true
  validates :status, presence: true

  accepts_nested_attributes_for :address

  # STI setup
  self.inheritance_column = "type"

  delegate :email, to: :user, allow_nil: true
end
