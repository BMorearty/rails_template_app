class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  # Request to reset password.
  # You get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user

    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    redirect_to(root_path, notice: 'Instructions have been sent to your email.')
  end

  # This is the reset password form.
  def edit
    @token = params[:id]
    @user  = User.load_from_reset_password_token(params[:id])

    not_authenticated if @user.blank?
  end

  # This action fires when the user has subimtted the reset password form.
  def update
    @token = params[:id]
    @user  = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    # Make the password confirmation validation work.
    @user.password_confirmation = params[:user][:password_confirmation]

    # Clear the temporary token and update the password.
    if @user.change_password!(params[:user][:password])
      redirect_to(root_path, notice: 'Password was successfully updated.')
    else
      render action: "edit"
    end
  end
end
