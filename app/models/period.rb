class Period < ApplicationRecord
  belongs_to :schedule
  belongs_to :school_class
end
