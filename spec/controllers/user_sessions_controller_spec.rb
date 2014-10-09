require 'spec_helper'

describe UserSessionsController, type: :controller do

  describe "GET 'new' (/login)" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      user = FactoryGirl.create :user
      post :create, email: user.email, password: 'secret'
      assert_redirected_to root_path
      assert_equal("Login successful", flash[:notice])
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      login_user(FactoryGirl.create :user)
      get :destroy
      assert_redirected_to root_path
      assert_equal("Logged out", flash[:notice])
    end

    it "when logged out should still allow logging out" do
      logout_user
      get :destroy
      assert_redirected_to root_path
      assert_equal("Logged out", flash[:notice])
    end
  end

end
