class CreateExaminations < ActiveRecord::Migration[8.0]
  def change
    create_table :examinations do |t|
      t.string :title
      t.date :expected_date

      t.timestamps
    end
  end
end
