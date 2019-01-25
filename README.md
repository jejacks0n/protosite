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

You can configure it in your initializers.

```ruby
Protosite.configure do |config|
  config.mount_at          = "/protosite"
  config.cookie_expiration = 30.minutes

  config.parent_controller = "ActionController::Base"
  config.parent_record     = "ActiveRecord::Base"
  config.parent_connection = "ActionCable::Connection::Base"
  config.parent_channel    = "ActionCable::Channel::Base"
end
``` 

## Usage

### Client Layer

You'll need two packages for Protosite to function correctly for users with editing capabilities.

In your primary application do something similar to the following to get the core functionality and rendering
capabilities of the Protosite core. Here's an example for Vue.

```javascript
import Vue from 'vue/dist/vue.js'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueProtosite from '@legwork/vue-protosite'

import App from 'views/app'
// import Work from 'views/work'
// import Hero from 'components/hero'

Vue.use(Vuex)
Vue.use(VueRouter)
Vue.use(VueProtosite)

// Setup the store. Protosite requires the store to resolve templates and
// components, as well to use any pages if they're present. If there are no
// pages present Protosite will attempt to load pages from the API.
const store = new Vuex.Store({
  state: {
    pages: window.data.pages,
    resolver: {
      // 'work-template': Work,
      // 'hero': Hero,
    },
  },
})

// Setup the router. Protosite will optionally add in all routes for the page
// hierarchy if a router is provided. Handling would need to be implemented on
// your own if you don't include the router.
//
// Here we create a catchall route and tell protosite which page to use. This
// can be used to create aliases, or redirects, using just the pages unique ID.
const router = new VueRouter({
  mode: 'history',
  fallback: false,
  routes: [
    { path: '*', page: 'error_404' },
  ],
})

// Setup protosite. Protosite requires the store and for the store to have a
// resolver and optionally a pages array.
//
// Protosite can be instantiated with some configuration options to change
// behavior as well. To provide any override though, a deep understanding of
// the implementation is needed.
//
// resolverComponent: CustomResolver,
// pageComponent: CustomPage,
// storeModule: CUSTOM_STORE,
//
// If a user is signed in with the correct access privileges, the Protosite
// interface pack will be loaded and presented to the user. The Protosite
// interface can be configured and modified in the protosite.js pack.
const protosite = new VueProtosite({ store, router, logger: () => null })

// Render the app to the page.
document.addEventListener('DOMContentLoaded', () => {
  new Vue({ store, router, protosite, el: '#root', components: { App } })
})
````

To enable the editing capabilities you'll need to create another pack. Create a `protosite.js` file in your packs path
and setup the following.

```javascript
import Protosite from '@legwork/vue-protosite/interface'

// You can configure the Protosite interface here and override functionality of
// any of the base components if you'd like. The Protosite interface exposes
// most of itself for the express purpose of being extensible and flexible. 

// Finally, we expose this so Protosite core can instantiate it and give us our
// CMA interface.
window.Protosite = Protosite
```


### API Layer

In the view you can use the `pages(depth: 2, attrs: 'id, data')` helper method to statically load in the pages. You can
specify the depth and which attributes to query.

```slim
doctype html
html
  head
    title Protosite Demo
    link rel="shortcut icon" href="/assets/favicon.ico"
    meta name="author" content="Legwork"
    = javascript_tag { raw "window.data = #{pages(depth: 5).to_json}" }
    = javascript_pack_tag "application.js"
    = stylesheet_pack_tag "application.css"
  body
    div#root
      App.application
```

## Development / Contributing

Clone the repo, and have ruby and node installed. To get things setup for development you need to link the node package.
You can do this from the project root.

- `yarn link`
- `yarn link "@legwork/vue-protosite"`

Next, you'll want a database and a user to connect with, so run the seeds. This will give you an admin@legworkstudio.com / password
user and login and some default page data.

- `bundle install`
- `yarn install`
- `rails app:db:reset`

Create a symlink for node modules

- `cd spec/dummy && ln -s ../../node_modules`

You can start the server with foreman (or whatever you want to do, but this works nice).

- `foreman start -f spec/dummy/Procfile`

After you have the server, you can browse to [the graphiql interface](http://localhost:3000/protosite/graphiql) to
inspect the schema and to run test queries etc.

#### Notes / Todo:

The api allows loading the page hierarchy -- parents, and child pages, and while the parent part is versionable, the
children aren't yet, unless we query inside the json. 
