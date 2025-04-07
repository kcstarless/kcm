class RemoveCategoryFromShops < ActiveRecord::Migration[8.0]
  def change
    remove_column :shops, :category, :string
  end
end
