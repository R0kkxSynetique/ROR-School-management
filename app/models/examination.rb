class Examination < ApplicationRecord
  belongs_to :person
  belongs_to :course
  has_many :grades, dependent: :destroy
end
