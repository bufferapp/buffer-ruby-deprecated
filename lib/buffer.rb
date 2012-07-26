require "buffer/version"
require 'faraday'
require 'multi_json'

module Buffer
  class Client

    attr_accessor :token

    # Initialize a new Buffer::Client
    #
    # Also sets up a Faraday connection object
    #
    # token - string access token for use with all API requests
    def initialize(token)
      if token.kind_of? String
        @token = token
      else
        raise ArgumentError, "token must be a string"
      end

      @conn = Faraday.new :url => 'https://api.bufferapp.com/1/'
    end

    # api is the root method of the Client, handling all requests.
    #
    # type - :get or :post
    # url - enpoint uri, with or without .json
    def api(type, uri)
      uri += '.json' unless uri =~ /\.json$/
      res = @conn.get uri, :access_token => @token
      if res.body && res.body.length >= 2
        MultiJson.load res.body
      else
        nil
      end
    end

  end
end
