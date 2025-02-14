class AddEmployeesToExaminations < ActiveRecord::Migration[8.0]
  def change
    add_reference :examinations, :employee, null: false, foreign_key: { to_table: :people }
  end
end
