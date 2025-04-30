# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_cart

  def show
    # Show the cart contents
    @cart_items = @cart.cart_items.includes(:product)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("tf-cart", partial: "shared/form_cart")
      end
    end
  end

  def update_delivery
    respond_to do |format|
      if @cart.update(cart_delivery_params)
        flash.now[:notice] = "Delivery details were successfully saved."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-cart", partial: "shared/form_cart")
          ]
        end
      else
        flash.now[:alert] = "Failed to save delivery details: #{@cart.errors.full_messages.join(', ')}"
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  private

  def ensure_authenticated
    redirect_to new_session_path, alert: "Please sign in to view your cart" unless authenticated?
  end

  def set_cart
    @cart = Current.user.active_cart

    # Create a cart if the user doesn't have one
    if @cart.nil?
      @cart = Cart.create(user: Current.user)
      Current.user.update(active_cart: @cart)
    end
  end

  def cart_delivery_params
    params.require(:cart).permit(:delivery_method, :date_slot, :time_slot)
  end
end
