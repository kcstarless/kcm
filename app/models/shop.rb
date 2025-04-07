class Shop < ApplicationRecord
  has_and_belongs_to_many :traders
  has_and_belongs_to_many :categories
  has_many :products

  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :location, :phone_number, :email_address, presence: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
end
