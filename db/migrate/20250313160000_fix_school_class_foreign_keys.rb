class FixSchoolClassForeignKeys < ActiveRecord::Migration[8.0]
  def change
    # Fix courses_school_classes join table
    rename_column :courses_school_classes, :class_id, :school_class_id

    # Fix people_school_classes join table
    rename_column :people_school_classes, :class_id, :school_class_id

    # Fix school_classes_students join table
    rename_column :school_classes_students, :class_id, :school_class_id
  end
end
