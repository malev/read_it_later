module ReadItLater
  class Header
    TYPES = {
      "200" => "Request was successful",
      "400" => "Invalid request, please make sure you follow the documentation for proper syntax",
      "401" => "Username and/or password is incorrect",
      "403" => "Rate limit exceeded, please wait a little bit before resubmitting",
      "503" => "Read It Later's sync server is down for scheduled maintenance"
    }

    AVAILABLE_METHODS = %w(x-limit-user-limit x-limit-user-remaining x-limit-user-reset x-limit-key-limit x-limit-key-remaining x-limit-key-reset)

    def initialize(header)
       @header = header
    end

    def status
      st = @header["status"][0][0..2]
      [st, TYPES[st]]
    end

    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^x\-limit/ && @header.key?(sym)
        @header[sym]
      else
        super
      end
    end

    def respond_to?(sym, include_private=false)
      if sym.to_s =~ /^x\-limit/ && @header.key?(sym)
        true
      else
        super
      end
    end
  end
end
