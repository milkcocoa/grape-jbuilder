# Grape::Jbuilder

Use [Jbuilder](https://github.com/rails/jbuilder) templates in [Grape](https://github.com/intridea/grape)!

This gem is completely based on [grape-rabl](https://github.com/LTe/grape-rabl).

[![Build Status](https://travis-ci.org/milkcocoa/grape-jbuilder.png?branch=master)](http://travis-ci.org/milkcocoa/grape-jbuilder)

## Installation

Add this line to your application's Gemfile:

    gem 'grape-jbuilder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-jbuilder

## Usage

### Require grape-jbuilder

```ruby
# config.ru
require 'grape/jbuilder'
```

### Setup view root directory
```ruby
# config.ru
require 'grape/jbuilder'

use Rack::Config do |env|
  env['api.tilt.root'] = '/path/to/view/root/directory'
end
```

### Tell your API to use Grape::Formatter:: Jbuilder

```ruby
class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::Jbuilder
end
```

### Use Jbuilder templates conditionally

Add the template name to the API options.

```ruby
get '/user/:id', jbuilder: 'user.jbuilder' do
  @user = User.find(params[:id])
end
```

You can use instance variables in the Jbuilder template.

```ruby
json.user do
  json.(@user, :name, :email)
  json.project do
    json.(@project, :name)
  end
end
```

### Use Jbuilder templates dynamically

```ruby
get ':id' do
  user = User.find_by(id: params[:id])
  if article
    env['api.tilt.template'] = 'users/show'
    env['api.tilt.locals']   = {user: user}
  else
    status 404
    {'status' => 'Not Found', 'errors' => "User id '#{params[:id]}' is not found."}
  end
end
```

## You can omit .jbuilder

The following are identical.

```ruby
get '/home', jbuilder: 'view'
get '/home', jbuilder: 'view.jbuilder'
```

### Example

```ruby
# config.ru
require 'grape/jbuilder'

use Rack::Config do |env|
  env['api.tilt.root'] = '/path/to/view/root/directory'
end

class UserAPI < Grape::API
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  # use Jbuilder with 'user.jbuilder' template
  get '/user/:id', jbuilder: 'user' do
    @user = User.find(params[:id])
  end

  # do not use jbuilder, fallback to the defalt Grape JSON formatter
  get '/users' do
    User.all
  end
end
```

```ruby
# user.jbuilder
json.user do
  json.(@user, :name)
end
```

## Usage with Rails

Create a grape application.

```ruby
# app/api/user.rb
class MyAPI < Grape::API
  format :json
  formatter :json, Grape::Formatter::Jbuilder
  get '/user/:id', jbuilder: 'user' do
    @user = User.find(params[:id])
  end
end
```

```ruby
# app/views/api/user.jbuilder
json.user do
  json.(@user, :name)
end
```

Edit your **config/application.rb** and add view path

```ruby
# application.rb
class Application < Rails::Application
  config.middleware.use(Rack::Config) do |env|
    env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api'
  end
end
```

Mount application to Rails router

```ruby
# routes.rb
GrapeExampleRails::Application.routes.draw do
  mount MyAPI , at: '/api'
end
```

## Rspec

See "Writing Tests" in https://github.com/intridea/grape.

Enjoy :)


## Special Thanks

Special thanks to [@LTe](https://github.com/LTe) because this gem is completely based on [grape-rabl](https://github.com/LTe/grape-rabl).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
