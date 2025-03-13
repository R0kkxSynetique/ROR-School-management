class AddDeanTypeToEmployees < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      UPDATE people
      SET type = 'Dean'
      WHERE type = 'Employee' AND id IN (
        SELECT id FROM people WHERE username LIKE 'dean%'
      )
    SQL
  end

  def down
    execute <<-SQL
      UPDATE people
      SET type = 'Employee'
      WHERE type = 'Dean'
    SQL
  end
end
