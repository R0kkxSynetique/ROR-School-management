class AddCoursesToExaminations < ActiveRecord::Migration[8.0]
  def change
    add_reference :examinations, :course, null: false, foreign_key: true
  end
end
