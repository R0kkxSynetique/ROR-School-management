class RemoveScheduleAndSchoolClassFromPeriods < ActiveRecord::Migration[8.0]
  def change
    remove_reference :periods, :schedule, null: false, foreign_key: true
    remove_reference :periods, :school_class, null: false, foreign_key: true
  end
end
