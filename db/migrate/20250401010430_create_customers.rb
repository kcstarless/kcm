class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true # Adds a reference to the users table
      t.string :name, null: false                       # Adds a name column
      t.string :preferred_delivery_method, default: "pickup" # Adds a preferred_delivery_method column with a default value

      t.timestamps
    end
  end
end
