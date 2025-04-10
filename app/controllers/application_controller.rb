class ApplicationController < ActionController::Base
  include Authentication
  before_action :initialize_cart

  private

  def initialize_cart
    if authenticated? # Ensure the user is logged in
      current_user.carts.find_or_create_by(status: "active")
    end
  end
end
