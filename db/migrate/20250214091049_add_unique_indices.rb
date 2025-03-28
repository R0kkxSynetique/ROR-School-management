class AddUniqueIndices < ActiveRecord::Migration[8.0]
  def change
    add_index :people, :username, unique: true
    add_index :people, :email, unique: true
    add_index :specializations, :name, unique: true
    add_index :courses, :name, unique: true
    add_index :rooms, :name, unique: true
    add_index :classes, :uid, unique: true
  end
end
