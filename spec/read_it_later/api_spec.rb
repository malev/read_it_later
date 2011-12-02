require 'spec_helper'

describe ReadItLater::Api do
  describe "working as an object" do
    it "should handle the apikey" do
      api = ReadItLater::Api.new("apikey")
      api.apikey.should == "apikey"
    end
  end

  describe "work as an object with a user" do
    before :all do
      FakeWeb.allow_net_connect = false
    end

    before do
      @user = ReadItLater::User.new("username", "password")
      @ril = ReadItLater::Api.new("apikey")
    end

    it "authenticate the user with valid data" do
      url = "https://readitlaterlist.com/v2/auth?username=username&password=password&apikey=apikey"
      FakeWeb.register_uri(:get, url, 
                           :body => "200 OK",
                           :status => ["200", "OK"])

      @ril.authenticate(@user).body.should  eql("200 OK")
    end
  end
end
