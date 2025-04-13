class AddDeliveryMethodToCartsAndRemovePreferredDeliveryMethodsFromCustomers < ActiveRecord::Migration[8.0]
  def change
    # Add delivery_method column to carts table
    add_column :carts, :delivery_method, :string

    # Remove preferred_delivery_methods column from customers table
    remove_column :customers, :preferred_delivery_method, :string
  end
end
