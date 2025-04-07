class UpdateNameColumns < ActiveRecord::Migration[8.0]
  def change
    # Remove the `name` column from customers, admins, and traders
    remove_column :customers, :name, :string
    remove_column :admins, :name, :string
    remove_column :traders, :name, :string

    # Add `first_name` and `last_name` columns to users without NOT NULL constraint
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    # Populate existing rows with default values
    User.update_all(first_name: "Default", last_name: "User")

    # Add NOT NULL constraint after populating existing rows
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
  end
end
