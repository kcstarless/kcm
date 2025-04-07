class AddChangesToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :location, :string, null: false
    add_column :shops, :phone_number, :string, null: false
    add_column :shops, :email_address, :string, null: false
    add_column :shops, :category, :string, null: false
  end
end
