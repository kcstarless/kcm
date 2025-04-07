class Category < ApplicationRecord
  has_and_belongs_to_many :products
  has_and_belongs_to_many :shops

  # Validations
  validates :name, presence: true, uniqueness: true
end
