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

  def delivery_details
    delivery_method = active_cart.delivery_method
    time_slot = active_cart.time_slot
    date_slot = active_cart.date_slot

    formatted_date = date_slot.strftime("%a #{date_slot.day}#{ordinal(date_slot.day)} of %B") if date_slot.present?

    details = delivery_method.to_s.capitalize
    details += " on #{formatted_date}" if formatted_date.present?
    details += ", #{time_slot}" if time_slot.present?

    details
  end

  private

  def ordinal(day)
    if (11..13).include?(day % 100)
      "th"
    else
      case day % 10
      when 1 then "st"
      when 2 then "nd"
      when 3 then "rd"
      else "th"
      end
    end
  end
end
