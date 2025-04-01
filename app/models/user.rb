class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :customer, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Add validation for email_address
  validates :email_address, presence: true, uniqueness: true
end
