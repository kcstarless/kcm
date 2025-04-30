class RemovePaymentFieldsFromCarts < ActiveRecord::Migration[8.0]
  def change
    remove_column :carts, :payment_intent_id, :string
    remove_column :carts, :payment_status, :string
  end
end
