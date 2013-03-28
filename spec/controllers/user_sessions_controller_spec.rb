require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new' (/login)" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      user = create :user
      post :create, email: user.email, password: 'secret'
      assert_redirected_to root_path
      assert_equal("Login successful", flash[:notice])
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      login_user(create :user)
      get :destroy
      assert_redirected_to root_path
      assert_equal("Logged out", flash[:notice])
    end

    it "when logged out should fail" do
      logout_user
      get :destroy
      assert_redirected_to login_path
    end
  end

end
