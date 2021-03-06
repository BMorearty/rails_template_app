class UserSessionsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end
  
  def create
    if (@user = login(params[:email],params[:password],params[:remember]))
      set_user_cookies @user
      redirect_back_or_to root_path, notice: "Login successful"
    else
      flash.now[:alert] = "Login failed"
      render action: "new"
    end
  end
  
  def destroy
    logout
    clear_user_cookies
    redirect_to root_path, notice: 'Logged out'
  end

end
