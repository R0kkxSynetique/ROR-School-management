class CreateClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :classes do |t|
      t.string :uid
      t.string :name

      t.timestamps
    end
  end
end
