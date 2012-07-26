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

    describe 'api :get' do

      before do
        stub_get('user.json').
          with(:query => {:access_token => 'some_token'}).
          to_return(:body => fixture('user.json'),:headers => {:content_type => 'application/json; charset=utf-8'})
        stub_get('non_existent.json').
          with(:query => {:access_token => 'some_token'}).
          to_return(:body => '', :headers => {:content_type => 'application/json; charset=utf-8'})
      end

      it 'makes correct request to user.json with access token' do
        subject.api :get, 'user.json'
        a_get('user.json').
          with(:query => {:access_token => 'some_token'}).
          should have_been_made
      end

      it 'makes correct request to user.json when passed user' do
        subject.api :get, 'user'
        a_get('user.json').
          with(:query => {:access_token => 'some_token'}).
          should have_been_made
      end

      it 'returns correct parsed object from user' do
        res = subject.api :get, 'user'
        target = begin
          MultiJson.load fixture('user.json')
        end
        res.should eq(target)
      end

      it 'returns nill from non_existent' do
        res = subject.api :get, 'non_existent'
        target = nil
        res.should eq(target)
      end

    end

  end

end