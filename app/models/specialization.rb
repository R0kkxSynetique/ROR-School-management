class Specialization < ApplicationRecord
  has_and_belongs_to_many :people, join_table: "people_specializations"
end
