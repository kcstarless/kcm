class Customer < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :preferred_delivery_method, presence: true, inclusion: { in: %w[delivery pickup] }
end
