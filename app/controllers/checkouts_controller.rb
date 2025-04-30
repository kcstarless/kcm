class CheckoutsController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_cart
  before_action :validate_cart

  private

  def ensure_authenticated
    redirect_to new_session_path, alert: "Please sign in to checkout" unless authenticated?
  end

  def set_cart
    @cart = Current.user&.active_cart
    redirect_to cart_path, alert: "You don't have an active cart" unless @cart
  end

  def validate_cart
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Please add items before proceeding to checkout."
      return
    end

    unless @cart.delivery_method.present? && @cart.date_slot.present? && @cart.time_slot.present?
      redirect_to cart_path, alert: "Please complete delivery details before proceeding to checkout."
      nil
    end
  end
end
