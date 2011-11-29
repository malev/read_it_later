require 'spec_helper'

describe ReadItLater::Api do
  describe "#authenticate and #statusI and #text" do
    before :all do
      FakeWeb.allow_net_connect = false
    end

    it "should return true if the username and password are correct" do
      url = "https://readitlaterlist.com/v2/auth?username=correct&password=correct&apikey=c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
      FakeWeb.register_uri(:get, url, 
                           :body => "200 OK",
                           :status => ["200", "OK"])

      auth = ReadItLater::Api.authenticate(:username => "correct", :password => "correct")
      auth.should be_true
    end

    it "should return false if the information if wrong" do
      url =  "https://readitlaterlist.com/v2/auth?username=correct&password=INCORRECT&apikey=c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
      FakeWeb.register_uri(:get, url,
                           :body => "401 Unauthorized",
                           :status => ["401", "Unauthorized"])

      auth = ReadItLater::Api.authenticate(:username => "correct", :password => "INCORRECT")
      auth.should be_false
    end

    it "should show the status" do
      url = "https://readitlaterlist.com/v2/stats?username=correct&password=correct&apikey=c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
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
      status = ReadItLater::Api.status(:username => "correct", :password => "correct")
      status["x-limit-key-limit"].should_not be_nil
    end

    it "should return text version of a url" do
      url = "http://text.readitlaterlist.com/v2/text?url=http%3A%2F%2Fweblog.rubyonrails.org%2F2011%2F11%2F20%2Frails-3-1-3-has-been-released"
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

      text = ReadItLater::Api.text("http://weblog.rubyonrails.org/2011/11/20/rails-3-1-3-has-been-released")
      text.should match(/Rails/)
    end
  end
end

