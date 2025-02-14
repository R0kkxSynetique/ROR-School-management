class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :locality
      t.string :postal_code
      t.string :administrative_area
      t.string :country

      t.timestamps
    end
  end
end
