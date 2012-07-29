require 'buffer/version'
require 'faraday'
require 'multi_json'
require 'addressable/uri'
require 'active_support/core_ext'

module Buffer
  class Client

    attr_reader :token

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
      @addr = Addressable::URI.new
    end

    # api is the root method of the Client, handling all requests.
    #
    # type - HTTP verb, :get or :post
    # url - enpoint uri, with or without .json
    # data - hash or array of data to be sent in POST body
    def api(type, uri, data = {})
      uri << '.json' unless uri =~ /\.json$/
      res = if type == :get
        @conn.get uri, :access_token => @token
      elsif type == :post
        @conn.post do |req|
          req.url uri, :access_token => @token
          req.body = data.to_query
        end
      end
      # Return nil if the body is less that 2 characters long,
      # ie. '{}' is the minimum valid JSON, or if the decoder
      # raises an exception when passed mangled JSON
      begin
        MultiJson.load res.body if res.body && res.body.length >= 2
      rescue
      end
    end

  end
end
