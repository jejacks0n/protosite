say "Adding Protosite (and webpacker) to Gemfile"
gem "webpacker", "~> 4.0"
gem "protosite", github: "jejacks0n/protosite"

say "Adding Protosite initializer"
initializer "protosite.rb", <<-RUBY.strip_heredoc
  Protosite.configure do |config|
    config.mount_at          = "/protosite"
    config.cookie_expiration = 30.minutes

    config.parent_controller = "ActionController::Base"
    config.parent_record     = "ActiveRecord::Base"
    config.parent_connection = "ActionCable::Connection::Base"
    config.parent_channel    = "ActionCable::Channel::Base"
  end
RUBY

after_bundle do
  say "Installing client side libraries"
  rails_command "webpacker:install"
  rails_command "webpacker:install:vue"

  say "Adding Protosite to package.json"
  run "yarn add https://github.com/jejacks0n/protosite"

  say "Adding Protosite boiler plate code"
  file "app/javascript/packs/protosite.js", <<~JAVASCRIPT.strip_heredoc
    import {Interface as Protosite} from '@protosite/vue-protosite'

    // You can configure the Protosite interface here and override functionality of
    // any of the base components if you'd like. The Protosite interface exposes
    // most of itself for the express purpose of being extensible and flexible.

    // Finally, we expose this so Protosite core can instantiate it and give us our
    // CMA interface.
    window.Protosite = Protosite
  JAVASCRIPT

  append_to_file "app/javascript/packs/application.js", <<-JAVASCRIPT.strip_heredoc
    import Vue from 'vue/dist/vue.js'
    import Vuex from 'vuex'
    import VueRouter from 'vue-router'
    import VueProtosite from '@protosite/vue-protosite'

    import App from 'views/app'
    import Work from 'views/work'
    import Hero from 'components/hero'

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
          'work-template': Work,
          'hero': Hero,
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
        { path: '*', component: VueProtosite.Resolver, meta: { page: 'error_404' } },
      ],
    })

    // Setup protosite. Protosite requires the vuex store and for the store to have
    // a resolver object and optionally a pages array.
    //
    // If a user is signed in with the correct access privileges, the protosite.js
    // pack will be loaded and presented to the user. The Protosite interface can
    // be configured and modified in protosite.js.
    const protosite = new VueProtosite({ store, router, logger: () => null })

    // Render the app to the page.
    document.addEventListener('DOMContentLoaded', () => {
      new Vue({ store, router, protosite, el: '#root', components: { App } })
    })
  JAVASCRIPT

  say "Getting database setup for Protosite"
  rails_command "protosite:install:migrations"
  rails_command "db:migrate"

  say "Protosite is now installed 🎉", :green
end
