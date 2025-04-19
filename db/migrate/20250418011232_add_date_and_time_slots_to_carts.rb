class AddDateAndTimeSlotsToCarts < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :date_slot, :date
    add_column :carts, :time_slot, :string
  end
end
