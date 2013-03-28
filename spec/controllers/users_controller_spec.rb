require 'spec_helper'

describe UsersController do

  context "logged out" do
    describe "GET index" do
      it "assigns all users as @users" do
        create(:user)
        get :index
        assigns(:users).should be_nil
        assert_redirected_to login_path
      end
    end
  end

  context "logged in" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      login_user user
    end

    describe "GET index" do
      it "assigns all users as @users" do
        other_user
        get :index
        assigns(:users).sort.should eq([user, other_user])
      end
    end

    describe "GET edit" do
      it "lets a user edit his own settings" do
        get :edit, :id => user
        response.should be_ok
        assigns(:user).should eq(user)
      end

      it "lets a user edit 'current' user settings" do
        get :edit, :id => 'current'
        response.should be_ok
        assigns(:user).should eq(user)
      end

      it "does not let a user edit another user's settings" do
        get :edit, :id => other_user
        response.should be_not_found
        assigns(:user).should be_nil
      end
    end

  end

end
