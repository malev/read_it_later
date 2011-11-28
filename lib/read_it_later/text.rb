require 'httparty'

class Text
  include HTTParty
  base_uri "http://text.readitlaterlist.com/"

  def bring(query)
    get('/v2/text', :query => query)
  end
end
