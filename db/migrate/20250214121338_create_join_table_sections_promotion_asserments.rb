class CreateJoinTableSectionsPromotionAsserments < ActiveRecord::Migration[8.0]
  def change
    create_join_table :sections, :promotion_asserments do |t|
      # t.index [:section_id, :promotion_asserment_id]
      # t.index [:promotion_asserment_id, :section_id]
    end
  end
end
