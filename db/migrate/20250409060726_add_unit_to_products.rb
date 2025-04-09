class AddUnitToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :unit, :string, default: "each", null: false
  end
end
