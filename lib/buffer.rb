require "buffer/version"
require 'faraday'

module Buffer
  class Client

    attr_accessor :token

    # Initialize a new Buffer::Client
    #
    # Also sets up a Faray connection object
    #
    # token - string access token for use with all API requests
    def initialize(token)
      if token.kind_of?(String)
        @token = token
      else
        raise ArgumentError
      end

      @conn = Faraday.new :url => 'https://api.bufferapp.com/1/'
    end

    # api is the root method of the Client, handling all requests.
    #
    # type - :get or :post
    # url - enpoint uri, with or without .json
    def api(type, uri)
      uri += '.json' unless uri =~ /\.json$/
      @conn.get uri, :access_token => @token
    end

  end
end
