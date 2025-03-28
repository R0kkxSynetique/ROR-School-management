class Section < ApplicationRecord
  has_many :school_classes, dependent: :destroy
  has_and_belongs_to_many :promotion_asserments
end
