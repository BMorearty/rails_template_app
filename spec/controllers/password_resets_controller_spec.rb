require 'spec_helper'

RSpec.describe PasswordResetsController, type: :controller do

  describe "POST create" do
    it "pretends to succeed even if it doesn't find the user" do
      post :create
      expect(response).to be_redirect
      expect(flash[:notice]).to be_present
    end

    it "sends an email if it finds the user" do
      user = FactoryGirl.create :activated_user
      post :create, reset_email: user.email
      expect(response).to be_redirect
      expect(flash[:notice]).to be_present

      # This is the format in which ResqueMailQueue enqueues emails
      expect(SorceryMailer).to have_queued('klass' => "SorceryMailer", 'method' => :reset_password_email, 'args' => [user.id])

      ResqueSpec.perform_all :mail

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Reset your RailsTemplateApp password")
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      expect(ActionMailer::Base.deliveries.last.body).to include(user.reset_password_token)
    end
  end

  describe "GET edit" do
    it "redirects to the login path if it doesn't find the user" do
      get :edit, id: SecureRandom.hex(10)
      expect(response).to redirect_to(login_path)
    end

    it "shows the password-reset form" do
      user = FactoryGirl.create :activated_user
      user.update_attributes reset_password_token: SecureRandom.hex(10)
      get :edit, id: user.reset_password_token
      expect(response).to be_ok
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do
    it "redirects to the login path with no message the token is invalid" do
      patch :update, id: SecureRandom.hex(10)
      expect(response).to redirect_to(login_path)
      expect(flash).to be_empty
    end

    it "resets the user's password" do
      user = FactoryGirl.create :activated_user
      user.update_attributes reset_password_token: SecureRandom.hex(10)
      patch :update, id: user.reset_password_token, user: {
        password:              "abcd",
        password_confirmation: "abcd"
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Password was successfully updated.")
      expect(user.reload).to have_password("abcd")
    end
  end

end
