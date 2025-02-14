class CreateJoinTableEmployeesSpecializations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :employees, :specializations do |t|
      # t.index [:employee_id, :specialization_id]
      # t.index [:specialization_id, :employee_id]
    end
  end
end
