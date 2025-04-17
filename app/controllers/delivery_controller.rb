class DeliveryController < ApplicationController
  def check_postcode
    postcode = params[:postcode].to_s.strip
    puts "Checking postcode: #{postcode}"

    location = Geocoder.search("#{postcode}, Australia").first

    puts "Geocoded location: #{location.inspect}"

    if location
      distance = Geocoder::Calculations.distance_between(
        [ MARKET_LOCATION[:latitude], MARKET_LOCATION[:longitude] ],
        [ location.latitude, location.longitude ]
      )

      if distance <= 30
        render json: { valid: true, message: "<span style='color:green;'>Yes, We deliver to your area!</span>" }
      else
        render json: { valid: false, message: "<b><span style='color:red;'>Sorry</span></b>, we don't deliver to your area. we only deliver to select suburbs within 30km of King Charles Market.
        You can still place your order with <b>Click & Collect</b> or try another postcode." }
      end
    else
      render json: { valid: false, message: "Invalid postcode." }
    end
  end

  def update_delivery_method
    delivery_method = params[:delivery_method]
    postcode = params[:postcode]
    # # Validate delivery method
    # unless %w[delivery pickup].include?(delivery_method)
    #   render turbo_stream: turbo_stream.replace("tf-delivery-option", partial: "shared/error", locals: { message: "Invalid delivery method." }), status: :unprocessable_entity
    #   return
    # end

    # # Validate postcode (if applicable)
    # if delivery_method == "delivery" && postcode.blank?
    #   render turbo_stream: turbo_stream.replace("tf-delivery-option", partial: "shared/error", locals: { message: "Invalid postcode." }), status: :unprocessable_entity
    #   return
    # end

    # # Update the cart with the delivery method and postcode
    cart = current_user.active_cart

    if cart
      cart.update(delivery_method: delivery_method)
      render turbo_stream: turbo_stream.replace("tf-delivery-option", partial: "shared/form_setDatetime", locals: { cart: cart })
    end
  end
end
