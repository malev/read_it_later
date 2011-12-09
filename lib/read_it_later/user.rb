module ReadItLater
  class User

    attr_reader :username, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def valid?
      @username =~ /^[\d|\w|\_\-]{1,20}$/ && @password =~ /^[\d|\w]{1,20}$/
    end
  end
end
