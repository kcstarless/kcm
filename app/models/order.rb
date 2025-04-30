class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart

  # Validations
  validates :user, :cart, :total_amount, :status, :delivery_method, :date_slot, :time_slot, presence: true
  validates :status, inclusion: { in: %w[pending processing completed cancelled delivered] }
  validates :delivery_method, inclusion: { in: %w[delivery pickup] }

  # Validation for cart status - can't create an order with an already completed cart
  validate :cart_not_already_completed, on: :create

  private

  def cart_not_already_completed
    if cart && cart.status != "active"
      errors.add(:cart, "has already been processed")
    end
  end
end
