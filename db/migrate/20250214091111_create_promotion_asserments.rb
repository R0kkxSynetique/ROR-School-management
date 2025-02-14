class CreatePromotionAsserments < ActiveRecord::Migration[8.0]
  def change
    create_table :promotion_asserments do |t|
      t.date :effective_date
      t.string :condition

      t.timestamps
    end
  end
end
