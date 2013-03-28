require 'spec_helper'

describe "UserSessions" do
  let(:user) { create(:user) }

  describe "login" do
    describe "accessing a protected page" do
      before do
        # TODO: visit some_protected_path
      end

      it "redirects you to the login page" do
        current_path.should eq(login_path)
      end

      it "redirects you back where you were trying to go after you login" do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'secret'
        click_button 'Login'
        current_path.should eq(some_protected_path)
      end
    end
  end

  pending "logout"
end
