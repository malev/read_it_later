require 'spec_helper'

describe ReadItLater::Wrapper do
  describe "working as an object" do
    it "should handle the Wrapperkey" do
      Wrapper = ReadItLater::Wrapper.new("apikey")
      Wrapper.apikey.should == "apikey"
    end
  end

  describe "work as an object with a user" do
    before :all do
      FakeWeb.allow_net_connect = false
    end

    before do
      @user = ReadItLater::User.new("username", "password")
      @ril = ReadItLater::Wrapper.new("apikey")
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
    before :all do
      FakeWeb.allow_net_connect = false
    end

    before do
      @user = ReadItLater::User.new("username", "password")
      @ril = ReadItLater::Wrapper.new("apikey")
    end

    it "should retrieve all the user's unread list" do
      url = "https://readitlaterlist.com/v2/get?username=username&password=password&apikey=apikey&state=unread"
      response = {
        "status"=>1, 
        "list"=>{
          "120157042"=>{
            "item_id"=>"120157042", 
            "title"=>"P\u00E1gina/12 :: El pa\u00EDs :: Ultima sesi\u00F3n con alto impacto social", 
            "url"=>"http://www.pagina12.com.are/diario/elpais/1-182477-2011-12-01.html", 
            "time_updated"=>"1322746244", 
            "time_added"=>"1322746216", 
            "state"=>"0"}
          }, 
        "since"=>1322749368, 
        "complete"=>1
      }
      
      FakeWeb.register_uri(:get, url, response)

      response = @ril.get(@user, :state => :unread)
      response.should be_instance_of(Hash)
      response["list"].should_not be_nil
    end

    it "should retrieve 4 unread articles" do
      url = "https://readitlaterlist.com/v2/get?username=username&password=password&apikey=apikey&state=unread&count=2"
      response = { 
        "status"=>1, 
        "list"=>{
          "121544880"=>{
            "item_id"=>"121544880", 
            "title"=>"An Introduction To Rspec | Think Vitamin", 
            "url"=>"http://thinkvitamin.com/code/ruby-on-rails/an-introduction-to-rspec/", 
            "time_updated"=>"1323290918", 
            "time_added"=>"1323290918", 
            "state"=>"0"}, 
          "121409062"=>{
            "item_id"=>"121409062", 
            "title"=>"El Software-martillo", 
            "url"=>"http://endefensadelsl.org/el_software-martillo.html", 
            "time_updated"=>"1323231083", 
            "time_added"=>"1323231083", 
            "state"=>"0"}
          }, 
        "since"=>1323452654, 
        "complete"=>1
      } 

      FakeWeb.register_uri(:get, url, response)

      response = @ril.get(@user, :state => :unread, :count => 2)
      response.should be_instance_of(Hash)
      response["list"].should_not be_nil
    end
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

      @ril = ReadItLater::Wrapper.new("apikey")
      text = @ril.text("http://weblog.rubyonrails.org/2011/11/20/rails-3-1-3-has-been-released")
      text.should match(/Rails/)
    end
  end
end
