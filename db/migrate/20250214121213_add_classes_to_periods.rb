class AddClassesToPeriods < ActiveRecord::Migration[8.0]
  def change
    add_reference :periods, :classes, null: false, foreign_key: true
  end
end
