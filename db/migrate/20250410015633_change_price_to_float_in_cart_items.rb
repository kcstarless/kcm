class ChangePriceToFloatInCartItems < ActiveRecord::Migration[8.0]
  def change
    change_column :cart_items, :price, :float
  end
end
