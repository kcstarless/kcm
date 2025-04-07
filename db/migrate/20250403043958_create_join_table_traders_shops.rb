class CreateJoinTableTradersShops < ActiveRecord::Migration[8.0]
  def change
    create_join_table :traders, :shops do |t|
      # t.index [ :trader_id, :shop_id ]
      # t.index [ :shop_id, :trader_id ]
    end
  end
end
