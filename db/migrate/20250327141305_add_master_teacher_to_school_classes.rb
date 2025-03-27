class AddMasterTeacherToSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    add_reference :school_classes, :master_teacher, null: true, foreign_key: { to_table: :people }
  end
end
