class SorceryMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout "mailer"

  default from: "do-not-reply@railstemplateapp.com"

  def activation_needed_email(user_id)
    @user = User.find(user_id)
    @activation_url = confirm_user_email_url(@user, activation_token: @user.activation_token)

    mail to:      @user.email,
         subject: "Confirm your RailsTemplateApp account"
  end

  def activation_success_email(user_id)
    @user = User.find(user_id)
    mail to:      @user.email,
         subject: "Welcome to RailsTemplateApp"
  end

  def reset_password_email(user_id)
    @user = User.find(user_id)
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail to:      @user.email,
         subject: "Reset your RailsTemplateApp password"
  end
end
