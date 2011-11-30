require 'spec_helper'

describe ReadItLater::User do
  it "should initialize a user with username and password" do
    user= ReadItLater::User.new("username", "password")
    user.username.should eql("username")
    user.password.should eql("password")
  end

  it "should validate that the username and password are valid"
  
end
