class DropOrdersTable < ActiveRecord::Migration[8.0]
  def up
    # Drop the table directly
    drop_table :orders, if_exists: true
  end

  def down
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
      t.string :delivery_method
      t.date :date_slot
      t.string :time_slot
      t.text :address
      t.string :tracking_number

      t.timestamps
    end
  end
end
