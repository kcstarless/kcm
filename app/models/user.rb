class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :customer, dependent: :destroy
  has_one :admin, dependent: :destroy
  has_one :trader, dependent: :destroy
  has_many :carts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Validations
  validates :email_address, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def active_cart
    carts.find_or_create_by(status: "active")
  end
end
