class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  enum :status, { active: "active", completed: "completed", cancelled: "cancelled" }, validate: true

  # validates :status, presence: true
  # validates :status, presence: true, inclusion: { in: statuses.keys }

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def total_items
    cart_items.sum(:quantity)
  end
end
