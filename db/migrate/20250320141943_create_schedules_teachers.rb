class CreateSchedulesTeachers < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules_teachers, id: false do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: { to_table: :people }
      t.index [:schedule_id, :teacher_id], unique: true
      t.index [:teacher_id, :schedule_id], unique: true
    end
  end
end