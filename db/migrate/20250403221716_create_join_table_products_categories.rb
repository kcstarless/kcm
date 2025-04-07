class CreateJoinTableProductsCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :products, :categories do |t|
      t.index [ :product_id, :category_id ], unique: true
      t.index [ :category_id, :product_id ], unique: true
    end
  end
end
