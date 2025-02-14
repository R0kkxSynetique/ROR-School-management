class CreateJoinTableCoursesClasses < ActiveRecord::Migration[8.0]
  def change
    create_join_table :courses, :classes do |t|
      # t.index [:course_id, :class_id]
      # t.index [:class_id, :course_id]
    end
  end
end
