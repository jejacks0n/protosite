Protosite
=========

Protosite is a CMA/CMS that's comprised of a client layer and an API layer that can be used together, or in their
component parts. 

The client layer is built using Vue, with a core concept of that by defining the shape of all data we can provide
standard tooling to manipulate that data.

The API layer is built with Rails and GraphQL.

## Installation

### Client Layer

Add it to your `package.json` using yarn or npm.

```shell
yarn add https://github.com/legworkstudio/protosite
```

### API Layer

Add it to your gemfile.

```ruby
gem "protosite", github: "legworkstudio/protosite"
```

Get the migrations by running the install task.

```shell
rails protosite:install:migrations db:migrate
```

You can configuration it in your initializers.

```ruby
Protosite.configure do |config|
  config.mount_at          = "/custom_path"
  config.cookie_expiration = 30.minutes

  config.parent_controller = "ActionController::Base"
  config.parent_record     = "ActiveRecord::Base"
  config.parent_connection = "ActionCable::Connection::Base"
  config.parent_channel    = "ActionCable::Channel::Base"
end
``` 

If you're using ActionCable, you'll need to add Protosite to your connection class.

```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Protosite::Connection
  end
end

``` 

## Usage

### Client Layer

TODO: document this.

### API Layer

There's not a whole lot to document at this point. If you want to override things you can fairly easily. Have at it!

## Development

To get things setup for development you need to link the node package. You can do this all from the project root.

- `npm link`
- `npm link @legwork/vue-protosite`

You can start the server with foreman (or whatever you want to do, but this works nice).

- `foreman start -f spec/dummy/Procfile`

After you have the server, you can browse to [the graphiql interface](http://localhost:3000/protosite/graphiql) to
inspect the schema and to run test queries etc.

### Notes / Todo:

The api allows loading the page hierarchy -- parents, and child pages, and while the parent part is versionable, the
children aren't yet, unless we query inside the json. 
