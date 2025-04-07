class AddIndexesToTradersShops < ActiveRecord::Migration[8.0]
  def change
    add_index :shops_traders, [ :trader_id, :shop_id ], unique: true
    add_index :shops_traders, [ :shop_id, :trader_id ], unique: true
  end
end
