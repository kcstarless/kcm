class AddShopToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :shop, null: false, foreign_key: true
  end
end
