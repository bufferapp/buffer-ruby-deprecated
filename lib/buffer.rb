require "buffer/version"
require 'faraday'

module Buffer
  class Client

    attr_accessor :token

    # Initialize a new Buffer::Client
    #
    # token - string access token for use with all API requests
    def initialize(token)
      if token.kind_of?(String)
        @token = token
      else
        raise ArgumentError
      end
    end

    # api is the root method of the api, handling all requests.
    def api(type, uri)
      conn = Faraday.new :url => 'https://api.bufferapp.com/1/'
      res = conn.get uri, :access_token => @token
      res.body
    end

  end
end
