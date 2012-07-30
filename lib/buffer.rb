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

    # get is a shorthand method for api :get
    #
    # uri - string endpoint uri
    def get(uri)
      api :get, uri
    end

    # post is a shorthand method for api :post
    # 
    # uri - string endpoint uri
    # data - hash or array for POST body
    def post(uri, data = {})
      api :post, uri, data
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

  class User < Client

    def initialize(token)
      super
      invalidate
    end

    private

      # user is a method for handling the cache of the user
      # data from the Buffer API.
      #
      # Returns a hash of user data.
      def user
        @cache[:user] ||= get 'user'
      end

    public

      # invalidate wipes the cache so that future requests
      # rebuild it from server data
      def invalidate
        @cache = {}
      end

      # method_missing steps in to enable the helper methods
      # by trying to get a particular key from self.user
      #
      # Returns the user data or the result of super
      def method_missing(method, *args, &block)
        user[method.to_s] || super
      end

      def respond_to?(name)
        user.key_exist? name
      end

  end
end
