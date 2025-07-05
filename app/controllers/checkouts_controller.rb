class CheckoutsController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_cart
  before_action :validate_cart

  def create
    # Create a Stripe PaymentIntent
    begin
      payment_intent = Stripe::PaymentIntent.create(
        amount: (@cart.total_price * 100).to_i, # Amount in cents
        currency: "aud",
        payment_method: params[:payment_method_id],
        confirm: true,
        description: "Order from #{Current.user.email_address}",
        metadata: {
          user_id: Current.user.id,
          cart_id: @cart.id
        },
        # Use automatic payment methods instead of confirmation_method
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: "never"
        }
      )

      puts "PaymentIntent created: #{payment_intent.id}"

      if payment_intent.status == "succeeded"
        # Payment was successful, create the order
        puts "Payment succeeded: #{payment_intent.id}"
        @order = Order.new(
          user: Current.user,
          cart: @cart,
          total_amount: @cart.total_price,
          delivery_method: @cart.delivery_method,
          date_slot: @cart.date_slot,
          time_slot: @cart.time_slot,
          payment_intent_id: payment_intent.id,
          payment_status: "paid",
          first_name: params[:first_name],
          last_name: params[:last_name],
          phone: params[:phone],
          email: params[:email]
        )

        # Add address fields if delivery method is "delivery"
        if @cart.delivery_method == "delivery"
          @order.street_address = params[:street_address]
          @order.apartment = params[:apartment]
          @order.suburb = params[:suburb]
          @order.state = params[:state]
          @order.postcode = params[:postcode]
        end

        if @order.save
          # Mark cart as completed
          @cart.update(status: "completed")

          flash[:notice] = "Payment successful! Your order has been placed."

          # Show order confirmation in a modal by replacing the checkout frame
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update("flash", partial: "shared/flash"),
                # turbo_stream.replace("tf-login-delivery-links", partial: "shared/link_login_delivery"),
                turbo_stream.replace("checkout-frame", partial: "orders/confirmation", locals: { order: @order })
              ]
            end
          end
        else
          # If order creation fails despite successful payment
          @error_messages = @order.errors.full_messages.join(", ")
          puts "Order save failed: #{@error_messages}"

          flash[:notice] = "Payment processed but there was a problem creating your order: #{@error_messages}"

          respond_to do |format|
            format.html { redirect_to shop_path }
            format.turbo_stream do
              render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
            end
          end
        end
      else
        # Payment intent was created but not successful
        flash[:notice] = "Payment processing failed. Please try again."

        respond_to do |format|
          format.html { redirect_to shop_path }
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
          end
        end
      end

    rescue Stripe::CardError => e
      # Card was declined
      flash[:notice] = "Your card was declined: #{e.message}"

      respond_to do |format|
        format.html { redirect_to shop_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    rescue Stripe::StripeError => e
      # Some other Stripe error
      flash[:notice] = "An error occurred while processing your payment: #{e.message}"

      respond_to do |format|
        format.html { redirect_to shop_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    rescue => e
      # Some other error
      flash[:notice] = "An unexpected error occurred. Please try again later."

      respond_to do |format|
        format.html { redirect_to shop_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  # Add a new method to show the checkout view
  def new
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("tf-cart", partial: "shared/form_checkout")
      end
    end
  end

  private

  def order_params
    params.permit(
      :first_name, :last_name, :phone, :email,
      :street_address, :apartment, :suburb, :state, :postcode
    )
  end

  def ensure_authenticated
    unless authenticated?
      flash.now[:notice] = "Please sign in to checkout"

      respond_to do |format|
        format.html { redirect_to new_session_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  def set_cart
    @cart = Current.user&.active_cart
    unless @cart
      flash.now[:notice] = "You don't have an active cart"

      respond_to do |format|
        format.html { redirect_to cart_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
    end
  end

  def validate_cart
    if @cart.cart_items.empty?
      flash.now[:notice] = "Your cart is empty. Please add items before proceeding to checkout."

      respond_to do |format|
        format.html { redirect_to cart_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
      return
    end

    unless @cart.delivery_method.present? && @cart.date_slot.present? && @cart.time_slot.present?
      flash.now[:notice] = "Please complete delivery details before proceeding to checkout."

      respond_to do |format|
        format.html { redirect_to cart_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
      end
      nil
    end
  end
end
