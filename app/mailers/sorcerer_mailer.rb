class SorcererMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout "mailer"

  default from: "do-not-reply@railstemplateapp.com"

  def activation_needed_email(id)
    @user = User.find(id)
    @activation_url = confirm_user_email_url(@user, activation_token: @user.activation_token)

    mail to:      @user.email,
         subject: "Confirm your RailsTemplateApp account"
  end

  def activation_success_email(id)
    @user = User.find(id)
    mail to:      @user.email,
         subject: "Welcome to RailsTemplateApp"
  end

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail to:      @user.email,
         subject: "Reset your RailsTemplateApp password"
  end

  ###################################################################################
  # The code below this point is what makes Sorcerer send emails in the background.

  class << self
    def respond_to?(method)
      method =~ /\Adeliver_(\w)+/ || super
    end

    # map deliver_something(foo) to something(foo).deliver
    def method_missing(method, *args)
      if method =~ /\Adeliver_((\w)+)/
        send($1, *args).deliver
      else
        super
      end
    end
  end

  # You should configure Sorcerer to send emails using this class.
  # This uses resque_mail_queue to deliver an email in the background.
  class Background
    class << self
      def respond_to?(method, include_private=false)
        SorcererMailer.respond_to?(method, include_private) || super
      end

      def method_missing(method, *args)
        if SorcererMailer.respond_to?(method)
          model = args[0]
          args = args[1..-1]
          SorcererMailer.enqueue.send("deliver_#{method}", model.id, *args)
        else
          super
        end
      end
    end
  end
end
