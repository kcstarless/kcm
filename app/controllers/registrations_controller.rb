class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
    render partial: "shared/form_registration", locals: { user: @user }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_customer_for(@user)
      start_new_session_for @user
      flash.now[:notice] = "Successfully registered! Welcome, #{@user.first_name}!"
      # redirect_to shop_path
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.update("tf-login-delivery-links", partial: "shared/link_login_delivery")
          ]
        end
      end
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :first_name, :last_name)
  end

  def create_customer_for(user)
    user.create_customer(preferred_delivery_method: "pickup")
  end
end
