class AddConditionFieldsToPromotionAsserments < ActiveRecord::Migration[8.0]
  def change
    change_table :promotion_asserments do |t|
      t.string :condition_variable
      t.string :condition_operator
      t.integer :condition_value
      t.text :course_ids
    end

    # Data migration for existing records
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE promotion_asserments
          SET condition_variable = 'overall_average',
              condition_operator = '>=',
              condition_value = 40,
              course_ids = '[]'
          WHERE condition_variable IS NULL
        SQL
        remove_column :promotion_asserments, :condition
      end

      dir.down do
        add_column :promotion_asserments, :condition, :string
        execute <<-SQL
          UPDATE promotion_asserments
          SET condition = CONCAT(condition_variable, ' ', condition_operator, ' ', condition_value)
        SQL
      end
    end

    # Add not null constraints after data migration
    change_column_null :promotion_asserments, :condition_variable, false
    change_column_null :promotion_asserments, :condition_operator, false
    change_column_null :promotion_asserments, :condition_value, false
  end
end
