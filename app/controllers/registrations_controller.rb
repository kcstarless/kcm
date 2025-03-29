class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
     Rails.logger.debug "New action called, @user initialized"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "User was successfully created."
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
