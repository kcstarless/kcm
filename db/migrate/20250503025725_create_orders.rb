class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :payment_intent_id
      t.string :payment_status
      t.string :delivery_method
      t.date :date_slot
      t.string :time_slot
      t.string :street_address
      t.string :apartment
      t.string :suburb
      t.string :state
      t.string :postcode

      t.timestamps
    end
  end
end
