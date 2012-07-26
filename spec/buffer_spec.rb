require 'helper'

describe Buffer::Client do
  
  describe 'initialization' do

    it 'accepts a token' do
      client = Buffer::Client.new 'some_token'
      client.token.should eq('some_token')
    end

    it 'rejects an integer token' do
      lambda { client = Buffer::Client.new 123 }.should raise_error
    end

    it 'rejects an array token' do
      lambda { client = Buffer::Client.new [123, 'hello'] }.should raise_error
    end

    it 'rejects an hash token' do
      lambda { client = Buffer::Client.new :test => 123 }.should raise_error
    end

  end

  describe 'api' do

    subject do
      Buffer::Client.new 'some_token'
    end

    it 'responds to api' do
      subject.respond_to?(:api).should be_true
    end

    describe ':get' do

      before do
        stub_get('user.json').
          with(:query => {:access_token => 'some_token'}).
          to_return(:body => fixture('user.json'),:headers => {:content_type => 'application/json; charset=utf-8'} )
      end

      it 'gets user.json correctly' do
        subject.api :get, 'user.json'
        a_get('user.json').
          with(:query => {:access_token => 'some_token'}).
          should have_been_made
      end

    end

  end

end