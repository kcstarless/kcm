class AddCustomerDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phone, :string
    add_column :orders, :email, :string
  end
end
