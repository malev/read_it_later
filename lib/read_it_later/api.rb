require 'httparty'

module ReadItLater
  class Api

    attr_reader :apikey

    include HTTParty
    base_uri 'https://readitlaterlist.com'

    def initialize(apikey)
      @apikey = apikey
    end

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

    def self.authenticate(credentials)
      credentials[:apikey] = get_apikey
      query = credentials
      response = bring("/v2/auth", query)
      if response.code == 200
        true
      elsif response.code == 401
        false
      else
        raise ArgumentError
      end
    end

    #def self.bring(path, query)
      #response = if path =~ /text/
        #Text.bring(path, :query => query)
      #else
        #get(path, :query => query)
      #end
      #wrapper(response)
    #end

    #def self.wrapper(response)
      #Response.new(response)
    #end

    #def self.create(opt = {})
      #user = self.new opt[:username], opt[:password], get_apikey
      #raise ArgumentError unless user.valid?
      #query = { :username => @username, :passowrd => @passowrd, :apikey => @apikey}
      #resp = self.class.bring("/v2/signup", query)
      ## validate that the response is not 401
    #end

    #def self.authenticate(query = {})
      #query[:apikey]  get_apikey
      #bring("/v2/auth", query)
    #end

    #def initialize(username, password, apikey=nil)
      #@apikey = apikey.nil? ? get_apikey : apikey
      #@username = username
      #@passowrd = passowrd
    #end

    #def valid?
      #@username.length <= 20 && @passowrd <= 20
    #end

    #def wrapper(response)
      #Response.new(response)
    #end
  end
end
