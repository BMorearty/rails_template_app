require 'spec_helper'

describe "UserSessions", type: :request do
  let(:user) { FactoryGirl.create(:user) }

  describe "login" do
    describe "accessing a protected page" do
      before do
        # TODO: visit some_protected_path
      end

      it "redirects you to the login page" do
        expect(current_path).to eq(login_path)
      end

      it "redirects you back where you were trying to go after you login" do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'secret'
        click_button 'Login'
        expect(current_path).to eq(some_protected_path)
      end
    end
  end

  pending "logout"
end
