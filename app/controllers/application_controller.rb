class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login
  before_filter :mini_profiler, if: :logged_in?
  around_filter :set_time_zone, if: :logged_in?

private

  def not_authenticated
    redirect_to login_path
  end

  def mini_profiler
    if current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = current_user.time_zone
    yield
  ensure
    Time.zone = old_time_zone
  end

  def set_user_cookies(user)
    cookies[:username] = user.name
    cookies[:email] = user.email
  end

  def clear_user_cookies
    cookies.delete :username
    cookies.delete :email
  end
end
