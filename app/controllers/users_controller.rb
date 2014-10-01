class UsersController < ApplicationController
  skip_before_filter :require_login, only: [ :new, :create ]
  before_filter :find_users, only: :index
  before_filter :find_user, only: [ :show, :edit, :update, :destroy ]
  before_filter :new_user, only: [ :new, :create ]

  # GET /users
  def index
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  # GET /users/1/edit_password
  def edit
    render template: 'users/edit_password' if params[:edit_password]
  end

  # POST /users
  def create
    if @user.save
      if (@user = login(params[:user][:email], params[:user][:password], true))
        # I send the email by myself so I can put it in
        # background queue and only pass the user id, not the whole User object.
        SorceryMailer.enqueue.activation_needed_email(@user.id)
        set_user_cookies @user
        redirect_back_or_to root_path, notice: t('users.new.account_created')
      else
        flash.now[:alert] = t('users.new.could_not_login')
        render action: "new"
      end
    else
      render action: "new"
    end
  end

  # PUT /users/1
  # PUT /users/1/update_password
  def update
    if @user.update_attributes(user_params)
      notice = params[:edit_password] ? t('users.update.changed_password') : t('users.update.changed')
      redirect_to @user, notice: notice
    else
      render action: params[:edit_password] ? "edit_password" : "edit"
    end
  end

  # DELETE /users/1
  def destroy
    clear_user_cookies if @user == current_user
    @user.destroy
    redirect_to users_url
  end

  # GET /accounts/users/id/confirm_email?activation_token=abcd123
  #
  # Confirm the email address of a newly-signed-up user.
  def confirm_email
    @user = User.load_from_activation_token(params[:activation_token])
    if @user && @user.id == params[:id].to_i
      @user.activate!
      path = logged_in? ? root_path : login_path(email: @user.email)
      redirect_to path, notice: t('users.confirm_email.confirmed')
    else
      not_authenticated
    end
  end

  private

  def find_user
    @user ||= current_user if current_user && params[:id] == 'current' || params[:id] == current_user.id.to_s
    head :not_found unless @user
  end

  def new_user
    @user ||= User.new(user_params) if params[:user]
    @user ||= User.new
  end

  def find_users
    @users ||= User.all
  end

  def user_params
    # TODO: only allow user to update his own params
    params.require(:user).permit(:name, :email, :old_password, :password, :password_confirmation)
  end

end
