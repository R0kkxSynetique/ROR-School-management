class AddCoursesToSchedules < ActiveRecord::Migration[8.0]
  def change
    add_reference :schedules, :courses, null: false, foreign_key: true
  end
end
