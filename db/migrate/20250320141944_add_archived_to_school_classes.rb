class AddArchivedToSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    add_column :school_classes, :archived, :boolean, default: false, null: false
    add_column :school_classes, :archived_at, :datetime
  end
end
