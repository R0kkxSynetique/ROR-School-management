class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    # Core references
    add_reference :people, :address, null: false, foreign_key: true
    add_reference :courses, :room, null: false, foreign_key: true
    add_reference :classes, :section, null: false, foreign_key: true
    add_reference :examinations, :person, null: false, foreign_key: true
    add_reference :examinations, :course, null: false, foreign_key: true
    add_reference :grades, :examination, null: false, foreign_key: true
    add_reference :grades, :student, null: false, foreign_key: { to_table: :people }
    add_reference :schedules, :courses, null: false, foreign_key: true
    add_reference :periods, :schedule, null: false, foreign_key: true
    add_reference :periods, :classes, null: false, foreign_key: true

    # Join tables
    create_join_table :courses, :people do |t|
      t.index [ :course_id, :person_id ]
      t.index [ :person_id, :course_id ]
    end

    create_join_table :classes, :courses do |t|
      t.index [ :class_id, :course_id ]
      t.index [ :course_id, :class_id ]
    end

    create_join_table :courses, :specializations do |t|
      t.index [ :course_id, :specialization_id ]
      t.index [ :specialization_id, :course_id ]
    end

    create_join_table :people, :specializations do |t|
      t.index [ :person_id, :specialization_id ]
      t.index [ :specialization_id, :person_id ]
    end

    create_join_table :grades, :people do |t|
      t.index [ :grade_id, :person_id ]
      t.index [ :person_id, :grade_id ]
    end

    create_join_table :classes, :people do |t|
      t.index [ :class_id, :person_id ]
      t.index [ :person_id, :class_id ]
    end

    create_join_table :classes, :students do |t|
      t.index [ :class_id, :student_id ]
      t.index [ :student_id, :class_id ]
    end

    create_join_table :sections, :promotion_asserments do |t|
      t.index [ :section_id, :promotion_asserment_id ], name: 'idx_sections_promotions'
      t.index [ :promotion_asserment_id, :section_id ], name: 'idx_promotions_sections'
    end
  end
end
