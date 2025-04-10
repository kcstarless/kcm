class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  before_action :prevent_direct_access_to_new, only: :new

  def new
    @user = User.new
    render partial: "shared/form_login", locals: { user: @user }
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password, :first_name, :last_name))
      start_new_session_for user
      flash.now[:notice] = "Welcome back, #{user.first_name}!" # Use flash.now
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-login-delivery-links", partial: "shared/link_login_delivery"),
            turbo_stream.update("tf-cart-icon", partial: "shared/cart_icon")
          ]
        end
        format.html { redirect_to root_path } # Added fallback for non-Turbo requests
      end
    else
      flash.now[:alert] = "Invalid email address or password." # Use flash.now
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html { redirect_to new_session_path } # Added fallback for non-Turbo requests
      end
    end
  end

  def destroy
    if terminate_session
      flash[:notice] = "You have been logged out successfully."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-login-delivery-links", partial: "shared/link_login_delivery"),
            turbo_stream.update("tf-cart-icon", partial: "shared/cart_icon")
          ]
        end
        format.html { redirect_to root_path } # Added fallback for non-Turbo requests
      end
    else
      flash[:alert] = "Logout failed. Please try again."
      redirect_to root_path
    end
  end

  private

  def prevent_direct_access_to_new
    unless request.xhr? || request.format.turbo_stream?
      redirect_to root_path, alert: "Direct access to this page is not allowed."
    end
  end
end
