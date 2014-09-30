require 'spec_helper'

RSpec.describe PasswordResetsController, type: :controller do

  describe "POST create" do
    it "returns http success" do
      post :create
      expect(response).to be_redirect
      expect(flash[:notice]).to be_present
    end
  end

  describe "GET edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    it "returns http success" do
      patch :update
      expect(response).to have_http_status(:success)
    end
  end

end
