require 'httparty'

class Api
  include HTTParty
  base_uri 'https://readitlaterlist.com'

  def self.text(options = {})
    apikey ||= get_apikey
    url = options[:url]
    mode = options[:mode] ? options[:mode] : "less"
    images = options[:images] ? options[:images] : 0
    query = { :url => url, :mode => mode, :images => images, :apikey => apikey}

    bring("/v2/text", :query => query)
  end

  def self.status
    apikey ||= get_apikey
    query = { :apikey => apikey}
    bring('/v2/api', query)
  end

  def self.get_apikey
    "c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
  end

  def self.bring(path, query)
    response = if path =~ /text/
      Text.bring(path, :query => query)
    else
      get(path, :query => query)
    end
    wrapper(response)
  end

  def self.wrapper(response)
    Response.new(response)
  end

  def self.create(opt = {})
    user = self.new opt[:username], opt[:password], get_apikey
    raise ArgumentError unless user.valid?
    query = { :username => @username, :passowrd => @passowrd, :apikey => @apikey}
    resp = self.class.bring("/v2/signup", query)
    # validate that the response is not 401
  end

  def initialize(username, password, apikey=nil)
    @apikey = apikey.nil? ? get_apikey : apikey
    @username = username
    @passowrd = passowrd
  end

  def valid?
    @username.length <= 20 && @passowrd <= 20
  end

  def wrapper(response)
    Response.new(response)
  end


  def authenticate
    query = { :username => @username, :passowrd => @passowrd, :apikey => @apikey}
    response = self.class.bring
    # TODO: validate authenticaion
  end
end
