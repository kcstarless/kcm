class AddDefaultAndNotNullToStatusInCarts < ActiveRecord::Migration[8.0]
  def change
    change_column_default :carts, :status, "active"
    change_column_null :carts, :status, false
  end
end
