class CreateJoinTableEmployeesClasses < ActiveRecord::Migration[8.0]
  def change
    create_join_table :employees, :classes do |t|
      # t.index [:employee_id, :class_id]
      # t.index [:class_id, :employee_id]
    end
  end
end
