class CreateGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :grades do |t|
      t.integer :value
      t.date :effective_date

      t.timestamps
    end
  end
end
