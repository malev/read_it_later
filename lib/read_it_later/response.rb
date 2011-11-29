module ReadItLater
  class Response
    attr_reader :header, :body, :text

    def initialize(response)
      @header = Header.new response.headers
      @body = response.body
    end

    def  status
      @header["status"]
    end
  end
end
