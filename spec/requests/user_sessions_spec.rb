require 'spec_helper'

describe "UserSessions", type: :request do
  let(:user) { FactoryGirl.create(:user) }

  def protected_path(user)
    edit_user_path(user)
  end

  describe "login" do
    describe "accessing a protected page" do
      before do
        visit protected_path(user)
      end

      it "redirects you to the login page" do
        expect(current_path).to eq(login_path)
      end

      describe "upon logging in" do
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'secret'
          click_button 'Login'
        end

        it "redirects you back where you were trying to go after you login" do
          expect(current_path).to eq(protected_path(user))
        end

        it "sets username and email cookies" do
          expect(get_me_the_cookie("username")[:value]).to eq(user.name)
          expect(get_me_the_cookie("email")[:value]).to eq(user.email)
        end
      end
    end
  end

  # Don't use Capybara in this block because logging out uses the DELETE method.
  describe "logout" do
    before do
      post_via_redirect user_sessions_path, email: user.email, password: 'secret'
      expect(cookies["username"]).to eq(user.name)
      expect(cookies["email"]).to eq(user.email)
    end

    it "uses the DELETE method for the logout link" do
      assert_select "a[href='/logout'][data-method=delete]"
    end

    it "deletes the login cookies" do
      delete logout_path
      expect(cookies["username"]).to eq("")
      expect(cookies["email"]).to eq("")
    end
  end
end
