class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, message: "must be greater than or equal to 0" }
  validates :product_id, uniqueness: { scope: :cart_id, message: "has already been taken" }

  before_create :set_price

  def item_subtotal
    price * quantity
  end

  private

  def set_price
    self.price ||= product.price
  end
end
