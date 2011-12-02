# The ReadItLater module is a wrapper over ReadItLate API
# to work with it as Ruby objects.
# The main idea is to provide a tool as close to the original
# behavior of the API.

# Author::    Marcos Vanetta  (mailto:marcosvanetta@gmail.com)
# Copyright:: Copyright (c) 2011 Marcos Vanetta 
# License::   LGPL

module ReadItLater
  autoload :Api, 'read_it_later/api'
  autoload :Version, 'read_it_later/version'
  autoload :Header,  'read_it_later/header'
  autoload :Response, 'read_it_later/response'
  autoload :Text, 'read_it_later/text'
  autoload :User, 'read_it_later/user'
  autoload :Wrapper, 'read_it_later/wrapper'
end

=begin
class ReadItLater
  include HTTParty
  base_uri 'https://readitlaterlist.com'

  def initialize(username, password, apikey=nil)
    @apikey = apikey.nil? ? get_apikey : apikey
    @username = username
    @passowrd = passowrd
  end

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
    bring('/v2/api', :query => query)
  end

  def self.get_apikey
    "c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
  end

  def create
    query = { :username => @username, :passowrd => @passowrd, :apikey => @apikey}
    bring("/v2/signup", :query =>  query)
  end

  def bring(path, query = {})
    response = if query[:query][:url]
      Text.bring(path, query)
    else
      get(path, queyr)
    end
    wrapper(response)
  end

  def wrapper(response)
    Response.new(response)
  end
end
=end
