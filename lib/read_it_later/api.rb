require 'httparty'

module ReadItLater
  class Api
    include HTTParty
    base_uri 'https://readitlaterlist.com'

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

    def self.status(credentials)
      credentials[:apikey] = get_apikey
      query = credentials
      response = bring("/v2/stats", query)
      response.headers
    end

    def self.bring(path, query)
      get(path, :query => query)
    end

    def self.text(url)
      Text.bring(:url => url).body
    end

    def self.get_apikey
      "c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
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
