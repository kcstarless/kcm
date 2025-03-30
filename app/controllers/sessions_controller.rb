class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    @user = User.new
    render partial: "shared/form_login", locals: { user: @user }
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      flash.now[:notice] = "Welcome back, #{user.email_address}!"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-login-delivery-links", partial: "shared/link_login_delivery")
          ]
        end
      end
    else
      flash.now[:alert] = "Invalid email address or password."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
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
            turbo_stream.update("tf-login-delivery-links", partial: "shared/link_login_delivery")
          ]
        end
      end
    else
      flash[:alert] = "Logout failed. Please try again."
      redirect_to root_path
    end
  end
end
