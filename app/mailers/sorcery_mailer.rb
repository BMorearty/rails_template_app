class SorceryMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout "mailer"

  default from: "do-not-reply@railstemplateapp.com"

  def activation_needed_email(user)
    @user = User.find(user["id"])
    @activation_url = confirm_user_email_url(@user, activation_token: @user.activation_token)

    mail to:      @user.email,
         subject: "Confirm your RailsTemplateApp account"
  end

  def activation_success_email(user)
    @user = User.find(user["id"])
    mail to:      @user.email,
         subject: "Welcome to RailsTemplateApp"
  end

  def reset_password_email(user)
    @user = User.find(user["id"])
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail to:      @user.email,
         subject: "Reset your RailsTemplateApp password"
  end
end
