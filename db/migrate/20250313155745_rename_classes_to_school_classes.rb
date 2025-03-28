class RenameClassesToSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    rename_table :classes, :school_classes

    # Rename join table references
    rename_table :classes_courses, :courses_school_classes
    rename_table :classes_people, :people_school_classes
    rename_table :classes_students, :school_classes_students

    # Rename foreign key column in periods
    rename_column :periods, :classes_id, :school_class_id
  end
end
