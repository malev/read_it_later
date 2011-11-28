require 'spec_helper'

describe ReadItLater::Header do
  before do
    header = {"content-location"=>["api.php"], 
              "content-type"=>["text/html"], 
              "date"=>["Sun, 27 Nov 2011 20:31:52 GMT"], 
              "p3p"=>["policyref='/w3c/p3p.xml', 
                      CP='ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE'"], 
              "server"=>["Apache/2.2.14 (Ubuntu)"], 
              "status"=>["200 OK"], 
              "tcn"=>["choice"], 
              "vary"=>["negotiate,Accept-Encoding"], 
              "x-limit-key-limit"=>["10000"], 
              "x-limit-key-remaining"=>["10000"], 
              "x-limit-key-reset"=>["3600"], 
              "x-powered-by"=>["PHP/5.3.2-1ubuntu4.9"], 
              "content-length"=>["6"], 
              "connection"=>["Close"]
    } 
    @header = ReadItLater::Header.new(header)
  end

  it "should return a array with the status" do
    @header.status.should be_instance_of(Array)
    @header.status[0].should == "200"
    @header.status[1].should be_instance_of(String)
  end

  it "should respond to all the x-limit... methods" do
    @header.should respond_to("x-limit-key-remaining")
  end

  it "should not respond to other method" do
    @header.should_not respond_to(:limit)
  end
end

