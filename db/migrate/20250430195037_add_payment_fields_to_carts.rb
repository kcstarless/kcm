class AddPaymentFieldsToCarts < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :payment_intent_id, :string
    add_column :carts, :payment_status, :string
  end
end
