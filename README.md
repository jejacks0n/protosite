Protosite
=========

Protosite is a CMA/CMS that's comprised of a client layer and an API layer that can be used together, or in their
component parts.

The API layer is built with Rails and GraphQL, and the client layer is built using Vue.

Protosite has a core concept of that by defining the shape of all data we can provide standard tooling to manipulate
and present that data. Which in practical terms manifests by simply using JSON Schema to define all CMSable component
data. We can define validation rules, input style (checkboxes vs. multi select for instance), and any number of
additional attributes to enable expressive ways to collect data from content teams.

Further, and maybe more importantly, the schema is useful in keeping code and data inline and versioned. If data doesn't
match the schema of the component trying to present it (for instance if the component has been updated with new
attributes), we can provide tooling to migrate data forward, or notify someone of the issue. 


## Installation

To create a new Rails app based on Protosite you can use the template when creating your app.

```shell
rails new -m https://raw.githubusercontent.com/jejacks0n/protosite/master/template.rb
```

Existing apps can use a similar technique, but require webpack to be installed and vue to be setup (via.
`rails webpacker:install:vue`) before running the template.

```shell
rails app:template LOCATION=https://raw.githubusercontent.com/jejacks0n/protosite/master/template.rb
rails protosite:install:migrations db:migrate
```

This adds a npm package and gem to your project. It also installs the boilerplate code that you can expand on with your
custom implementation.

### Configuration

After installation, you can configure it in your initializers (`config/initializers/protosite.rb`). You may also want to
review and make changes to the basic client implementation in the `application.js` file and editor implementation in the
`protosite.js` file.

### API Layer

In the view you can use the `pages(depth: 2, attrs: 'id, data')` helper method to statically load in the pages. You can
specify the depth and which attributes to query.

```slim
doctype html
html
  head
    title Protosite Demo
    link rel="shortcut icon" href="/assets/favicon.ico"
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
- `yarn link "@protosite/vue-protosite"`

Next, you'll want a database and a user to connect with, so run the seeds. This will give you an admin, with the login
of `admin@protosite` / `password` and some default page data.

- `bundle install`
- `yarn install`
- `rake app:db:reset app:db:test:prepare`

Create a symlink for node modules.

- `ln -s spec/dummy/node_modules node_modules`

You should now be able to run the specs.

- `rake` to run rubocop and the specs
- `rake spec` to just run the specs

You can start the server with foreman (or whatever you want to do, but this works nice).

- `foreman start -f spec/dummy/Procfile`

After you have the server, you can browse to [the graphiql interface](http://localhost:3000/protosite/graphiql) to
inspect the schema and to run test queries etc.

#### Notes / Todo:

The api allows loading the page hierarchy -- parents, and child pages, and while the parent part is versionable, the
children aren't yet, unless we query inside the json.


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2016 [jejacks0n](https://github.com/jejacks0n)

All licenses for the bundled Javascript libraries are included (MIT/BSD).


## Make Code Not War
