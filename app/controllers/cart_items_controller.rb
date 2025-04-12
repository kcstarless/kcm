class CartItemsController < ApplicationController
  def create
    # Find or create the active cart for the current user
    cart = current_user.carts.find_or_create_by(status: "active")
    cart_item = cart.cart_items.find_or_initialize_by(product_id: params[:product_id])

    # Ensure quantity is initialized to 0 if nil
    cart_item.quantity ||= 0

    # Update the quantity
    cart_item.quantity += params[:quantity].to_i

    if cart_item.save
      flash.now[:notice] = "Product added to cart successfully."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-cart-icon", partial: "shared/cart_icon"),
            turbo_stream.update("tf-cart", partial: "shared/form_cart")
          ]
        end
      end
    else
      flash.now[:alert] = "Failed to add product to cart."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  def update
    begin
      cart_item = current_user.carts.find_by(status: "active").cart_items.find(params[:id])
      if cart_item.update(quantity: params[:quantity])
        # flash.now[:notice] = "Item updated."
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("flash", partial: "shared/flash"),
              turbo_stream.update("tf-cart-icon", partial: "shared/cart_icon"),
              turbo_stream.update("tf-cart", partial: "shared/form_cart")
            ]
          end
        end
      else
        flash.now[:alert] = "Failed to update cart item."
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
          end
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = "Cart item not found."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  def destroy
    begin
      cart_item = current_user.carts.find_by(status: "active").cart_items.find(params[:id])
      if cart_item.destroy
        flash.now[:notice] = "Cart item removed successfully."
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("flash", partial: "shared/flash"),
              turbo_stream.update("tf-cart-icon", partial: "shared/cart_icon"),
              turbo_stream.update("tf-cart", partial: "shared/form_cart")
            ]
          end
        end
      else
        flash.now[:alert] = "Failed to remove cart item."
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
          end
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = "Cart item not found."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end
end
