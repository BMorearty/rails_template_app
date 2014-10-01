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

      it "redirects you back where you were trying to go after you login" do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'secret'
        click_button 'Login'
        expect(current_path).to eq(protected_path(user))
      end
    end
  end

  pending "logout"
end
