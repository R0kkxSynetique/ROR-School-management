class AddSchedulesToPeriods < ActiveRecord::Migration[8.0]
  def change
    add_reference :periods, :schedule, null: false, foreign_key: true
  end
end
