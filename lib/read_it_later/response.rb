class Response
  attr_reader :header, :body, :text

  def initialize(response)
    @header = Header.new response.headers
    @body = Body.new response.body
  end
end
