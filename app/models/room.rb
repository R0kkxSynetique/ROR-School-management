class Room < ApplicationRecord
  has_many :courses, dependent: :destroy
end
