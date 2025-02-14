class CreateJoinTableStudentsClasses < ActiveRecord::Migration[8.0]
  def change
    create_join_table :students, :classes do |t|
      # t.index [:student_id, :class_id]
      # t.index [:class_id, :student_id]
    end
  end
end
