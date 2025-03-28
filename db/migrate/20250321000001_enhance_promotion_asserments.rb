class EnhancePromotionAsserments < ActiveRecord::Migration[8.0]
  def change
    # Add new fields to promotion_asserments
    change_table :promotion_asserments do |t|
      t.string :name
      t.text :description
      t.boolean :active, default: true
      t.references :dean, foreign_key: { to_table: :people }
    end

    # Create table for promotion conditions
    create_table :promotion_conditions do |t|
      t.references :promotion_asserment, null: false, foreign_key: true
      t.string :condition_type # 'single_course', 'multiple_courses', or 'overall_average'
      t.decimal :minimum_grade, precision: 3, scale: 1
      t.decimal :weight, precision: 3, scale: 2, default: 1.0
      t.boolean :required, default: true
      t.timestamps
    end

    # Create join table for courses and promotion conditions
    create_table :courses_promotion_conditions do |t|
      t.references :course, null: false, foreign_key: true
      t.references :promotion_condition, null: false, foreign_key: true
      t.index [ :course_id, :promotion_condition_id ], name: 'idx_courses_conditions'
      t.index [ :promotion_condition_id, :course_id ], name: 'idx_conditions_courses'
    end

    # Remove the old condition column as it's being replaced by the new structure
    remove_column :promotion_asserments, :condition, :string
  end
end
