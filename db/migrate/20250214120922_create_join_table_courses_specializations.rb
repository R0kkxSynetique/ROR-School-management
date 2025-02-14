class CreateJoinTableCoursesSpecializations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :courses, :specializations do |t|
      # t.index [:course_id, :specialization_id]
      # t.index [:specialization_id, :course_id]
    end
  end
end
