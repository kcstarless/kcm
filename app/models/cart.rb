class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_one :order

  enum :status, { active: "active", completed: "completed", cancelled: "cancelled" }, validate: true

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def total_items
    cart_items.select(:product_id).distinct.count
  end
end
