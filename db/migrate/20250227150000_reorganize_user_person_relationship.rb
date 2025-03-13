class ReorganizeUserPersonRelationship < ActiveRecord::Migration[8.0]
  def change
    add_reference :people, :user, foreign_key: true, null: true

    remove_column :people, :email, :string

    change_column_null :people, :username, true
  end
end
