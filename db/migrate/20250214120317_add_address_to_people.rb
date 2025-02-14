class AddAddressToPeople < ActiveRecord::Migration[8.0]
  def change
    add_reference :people, :address, null: false, foreign_key: true
  end
end
