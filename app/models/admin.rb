class Admin < ApplicationRecord
  belongs_to :user

  # Define roles using an enum
  enum :role, {
    power_user: "power_user",
    root_user: "root_user"
  }, validate: true

  # Validations
  validates :role, presence: true
end
