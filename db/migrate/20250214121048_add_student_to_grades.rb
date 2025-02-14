class AddStudentToGrades < ActiveRecord::Migration[8.0]
  def change
    add_reference :grades, :student, null: false, foreign_key: { to_table: :people }
  end
end
