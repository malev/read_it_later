require 'httparty'

module ReadItLater
  class Text
    include HTTParty
    base_uri "http://text.readitlaterlist.com/"

    def self.bring(query)
      get('/v2/text', :query => query)
    end
  end
end
