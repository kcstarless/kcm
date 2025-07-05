class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart, optional: true

  validates :payment_status, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  # Validate address fields if delivery method is "delivery"
  with_options if: -> { delivery_method == "delivery" } do
    validates :street_address, presence: true
    validates :suburb, presence: true
    validates :state, presence: true
    validates :postcode, presence: true
  end
end
