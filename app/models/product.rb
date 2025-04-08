class Product < ApplicationRecord
  belongs_to :shop
  has_and_belongs_to_many :categories

  # Add support for image attachments
  has_one_attached :image

  # Validations
  validates :name, presence: true, uniqueness: { scope: :shop_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
