class CreateJoinTableShopsCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :shops, :categories do |t|
      t.index [ :shop_id, :category_id ]
      t.index [ :category_id, :shop_id ]
    end
  end
end
