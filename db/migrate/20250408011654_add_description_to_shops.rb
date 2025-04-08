class AddDescriptionToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :description, :text
  end
end
