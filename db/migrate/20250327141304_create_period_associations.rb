class CreatePeriodAssociations < ActiveRecord::Migration[8.0]
  def change
    add_reference :schedules, :period, null: true, foreign_key: true
    add_reference :school_classes, :period, null: true, foreign_key: true
  end
end
