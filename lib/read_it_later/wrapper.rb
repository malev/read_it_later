require 'httparty'

# The ReadItLater module is a wrapper over ReadItLate API
# to work with it as Ruby objects.
# The main idea is to provide a tool as close to the original
# behavior of the API.

# Author::    Marcos Vanetta  (mailto:marcosvanetta@gmail.com)
# Copyright:: Copyright (c) 2011 Marcos Vanetta 
# License::   LGPL
module ReadItLater
  class Wrapper

    # Holds the api_key assigned to this ReadItLater instance.
    attr_reader :apikey

    include HTTParty
    base_uri 'https://readitlaterlist.com'

    # Creates a new instance of ReadItLater Wrapper
    #
    # @param [String] The Apikey provide by ReadItLater.com 
    #
    #     @ril = ReadItLater.new("yourapikey")
    #
    def initialize(apikey)
      @apikey = apikey
    end

    # Check if the user credentials are valid.
    # 
    # @param [user] User instance from ReadItLater::User class
    # @return [Boolean] true or false
    #
    #     @user = ReadItLater.new("username", "password")
    #
    #     @ril = ReadItLater.new("yourapikey")
    #
    #     @ril.authenticate(@user) # -> true / false
    #
    def authenticate(user)
      response = self.class.get("/v2/auth", :query => generate_query(user))
      if response.code == 200
        true
      elsif response.code == 401
        false
      else
        raise ArgumentError
      end
    end

    def status(user)
      response = self.class.get("/v2/stats", :query => generate_query(user))
      response.headers
    end

    def text(url)
      Text.bring(:url => url, :apikey => @apikey).body
    end

    def generate_query(user = nil, options = {})
      pre_params = if user
        {:username => user.username,
         :password => user.password,
         :apikey => @apikey}
      else
        { :apikey => @apikey }
      end
      pre_params.merge(options)
    end

    def get(user, options = {})
      response = self.class.get("/v2/get", :query => generate_query(user, options))
      response.to_hash
    end
  end
end
