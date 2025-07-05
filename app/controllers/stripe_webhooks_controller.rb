class StripeWebhooksController < ApplicationController
  # Skip CSRF protection for webhooks since Stripe can't provide it
  skip_before_action :verify_authenticity_token

  def create
    # Get the webhook payload and signature
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    begin
      # Verify webhook signature and parse the event
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: "Invalid signature" }, status: 400
      return
    end

    # Handle the event
    case event.type
    when "payment_intent.succeeded"
      payment_intent = event.data.object
      # Handle successful payment intent
      puts "Payment succeeded for #{payment_intent.amount / 100.0}"
      # Add your business logic here (update order status, etc.)
    when "payment_intent.payment_failed"
      payment_intent = event.data.object
      # Handle failed payment intent
      puts "Payment failed for #{payment_intent.amount / 100.0}"
      # Add your business logic here (notify customer, etc.)
    else
      puts "Unhandled event type: #{event.type}"
    end

    # Return a 200 success response to acknowledge receipt of the event
    render json: { received: true }
  end
end
