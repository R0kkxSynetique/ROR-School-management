class CreateJoinTableEmployeesGrades < ActiveRecord::Migration[8.0]
  def change
    create_join_table :employees, :grades do |t|
      # t.index [:employee_id, :grade_id]
      # t.index [:grade_id, :employee_id]
    end
  end
end
