class AddArchivedToSpecializations < ActiveRecord::Migration[8.0]
  def change
    add_column :specializations, :archived, :boolean, default: false, null: false
  end
end
