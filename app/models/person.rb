class Person < ApplicationRecord
  belongs_to :address
  belongs_to :user, optional: true

  validates :username, presence: true, uniqueness: true
  validates :status, presence: true
  validates :phone_number, presence: true, format: {
    with: /\A(?:(?:\+\d{1,3}\s?)?\d{2,3}(?:\s?\d{3}){1,2}(?:\s?\d{2}){1,2})\z/,
    message: "must be a valid phone number format like '078 677 20 06' or '+41 78 682 25 65'"
  }

  accepts_nested_attributes_for :address

  # STI setup
  self.inheritance_column = "type"

  delegate :email, to: :user, allow_nil: true
end
