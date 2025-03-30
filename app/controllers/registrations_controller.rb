class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
    render partial: "shared/form_registration", locals: { user: @user }
  end

  def create
    puts params.inspect

    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to home_path, notice: "User was successfully created."
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
