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

      @ril.authenticate(@user).should be_true
    end

    it "should return false if the data is incorrect" do
      @user_false = ReadItLater::User.new("username", "incorrect")
      url = "https://readitlaterlist.com/v2/auth?username=username&password=incorrect&apikey=apikey"
      FakeWeb.register_uri(:get, url,
                           :body => "401 Unauthorized",
                           :status => ["401", "Unauthorized"])

      @ril.authenticate(@user_false).should be_false
    end

    it "should return the user status information" do
      url = "https://readitlaterlist.com/v2/stats?username=username&password=password&apikey=apikey"
      body = "{\"user_since\":1318984098,\"count_list\":\"78\",\"count_read\":\"62\",\"count_unread\":\"16\"}"
      header = {"content-location"=>["stats.php"], 
                 "content-type"=>["application/json"], 
                 "date"=>["Mon, 28 Nov 2011 22:12:39 GMT"], 
                 "server"=>["Apache/2.2.14 (Ubuntu)"], 
                 "status"=>["200 OK"], 
                 "tcn"=>["choice"], 
                 "vary"=>["negotiate"], 
                 "x-limit-key-limit"=>["10000"], 
                 "x-limit-key-remaining"=>["9980"], 
                 "x-limit-key-reset"=>["1423"], 
                 "x-limit-user-limit"=>["220"], 
                 "x-limit-user-remaining"=>["215"], 
                 "x-limit-user-reset"=>["1423"], 
                 "x-powered-by"=>["PHP/5.3.2-1ubuntu4.9"], 
                 "content-length"=>["81"], 
                 "connection"=>["Close"]} 
      response = {:body => body}.merge(header)  
      FakeWeb.register_uri(:get, url, response) 

      status = @ril.status(@user)
      status["x-limit-key-limit"].should_not be_nil
    end
  end

  describe "should get the user's list" do
    it "should retrieve all the user's list"
    it "should retrieve all the user's unread list"
    it "should retrieve 2 unread articles"
  end

  describe "should convert text without a user" do
    it "should return text version of a url" do
      url = "http://text.readitlaterlist.com/v2/text?apikey=apikey&url=http%3A%2F%2Fweblog.rubyonrails.org%2F2011%2F11%2F20%2Frails-3-1-3-has-been-released"
      body = "\n    <h2 nodeIndex='42'>Rails 3.1.3 has been released</h2>\n\n"
      header = {"date"=>["Tue, 29 Nov 2011 01:52:13 GMT"], 
                "server"=>["Apache/2.2.19 (Unix) mod_ssl/2.2.19 OpenSSL/0.9.8e-fips-rhel5 mod_bwlimited/1.4 PHP/5.3.6"], 
                "x-powered-by"=>["PHP/5.3.6"], 
                "status"=>["200 OK"], 
                "x-title"=>["Riding Rails: Rails 3.1.3 has been released"], 
                "x-resolved"=>["http://weblog.rubyonrails.org/2011/11/20/rails-3-1-3-has-been-released"], 
                "content-length"=>["1791"], 
                "connection"=>["close"], 
                "content-type"=>["text/html; charset=utf-8"]}
      response = {:body => body}.merge(header)
      FakeWeb.register_uri(:get, url, response)

      @ril = ReadItLater::Api.new("apikey")
      text = @ril.text("http://weblog.rubyonrails.org/2011/11/20/rails-3-1-3-has-been-released")
      text.should match(/Rails/)
    end
  end
end
