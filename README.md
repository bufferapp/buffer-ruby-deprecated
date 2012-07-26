# Buffer

Official API wrapper for [Buffer](http://bufferapp.com) covering user & profile management and adding, removing & editing updates, and more planned endpoints. See the [full API Documentation](http://bufferapp.com/developers/api/) for more.

For a Buffer OmniAuth strategy for authenticating your users with Buffer, see [omniauth-buffer2](/bufferapp/omniauth-buffer2).

## Installation

Add this line to your application's Gemfile:

    gem 'buffer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buffer

## Usage

### Client

The most basic usage of the wrapper involves creating a `Buffer::Client` and then making requests through that object. Since all requests to the Buffer API require an access token you must have first authorized a Buffer user, or otherwise have an access token. The [Buffer OmniAuth Strategy](http://github.com/bufferapp/omniauth-buffer2) can help with this.

Creating a new client is simple:

```ruby
buffer = Buffer::Client.new access_token
```

### API

You can use a client, or any subclass, to make GET & POST requests to the Buffer API. The exposed most low-level API methods are `get`, `post` and, the lowest level, `api`. 

#### `api`

`api` is the method at the root of the API, handling all requests.

```ruby
api (symbol) method, (string) url, (hash, options) params, (hash or array, optional) data
# for example:
buffer.api :get, 'user'
```

`method` must be either `:get` or `:post`

#### `get`

```ruby
user_data = buffer.get 'user'
user_profiles = buffer.get 'profiles', :limit => 3
```

`get` is just a thin layer over `api`, so the above is equivalent to:

```ruby
user_data = buffer.api :get, 'user'
user_profiles = buffer.get :get, 'profiles', :limit => 3
```

#### `post`

```ruby
user_data = buffer.post 'updates/create', :text => "Hello, world!", :profile_ids => ['123abc456', '789def123']
```

`post` is also a wrapper for `api`, so the above becomes:

```ruby
user_data = buffer.api :post, 'updates/create', :text => "Hello, world!", :profile_ids => ['123abc456', '789def123']
```
