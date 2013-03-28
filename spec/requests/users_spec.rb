require 'spec_helper'

describe "Users" do
  context "not logged in" do

  end

  context "logged in" do
    before do
      request_login
    end
  end
end
