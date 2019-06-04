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
  file "app/javascript/packs/protosite.js", <<-JAVASCRIPT.strip_heredoc
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

    // App is basically your top level layout, and can be simple. Here we just have
    // a loading indicator, some navigation and page level rendering.
    import App from 'views/app'

    // Home is a custom template. If you look at the pages data, you'll see that
    // the home page specifies a custom type of 'home-page', which we define in our
    // resolver that we pass to our store.
    import Home from 'views/home'

    // Hero is an example component. It's pretty simple, and again, you can see
    // that we're just importing it here because we expose it in our resolver.
    import Hero from 'components/hero'

    // Initialize Vue plugins.
    Vue.use(Vuex)
    Vue.use(VueRouter)
    Vue.use(VueProtosite)

    // Setup the store. Protosite requires the store to resolve templates and
    // components, as well to use any pages if they're present. If there are no
    // pages present Protosite will attempt to load pages from the API.
    const store = new Vuex.Store({
      state: {
        // The data as loaded into the page using `protosite_data`, this is
        // optional, and can be loaded via the api exclusively, though the downside
        // of that is reduced performance at load time. Generally it's best to load
        // a subset of data at initial load so navigation and similar can be
        // rendered.
        data: window.data,
        // The resolver is used to pull in page templates and components during
        // rendering. This is required, but it can provided to Protosite in other
        // ways -- check configuration options.
        resolver: {
          'home-page': Home,
          'hero': Hero,
        },
      },
    })

    // Setup the router. Protosite will optionally add in all routes for the page
    // hierarchy if a router is provided. Handling would need to be implemented on
    // your own if you don't include the router. Protosite adds a catch all route
    // that handles 404s (the error_404 page by default).
    const router = new VueRouter({
      mode: 'history',
      fallback: false,
      routes: [],
    })

    // Setup protosite. Protosite requires the vuex store and for the store to have
    // a resolver object and optionally some data (to avoid a round trip to the api
    // on initial load.)
    //
    // If a user is signed in with the correct access privileges, the protosite.js
    // pack will be loaded and presented to the user. The Protosite interface can
    // be configured and modified in protosite.js.
    const protosite = new VueProtosite({store, router})

    // Render the app to the page.
    document.addEventListener('DOMContentLoaded', () => {
      new Vue({store, router, protosite, el: '#root', components: {App}})
    })
  JAVASCRIPT

  file "app/javascript/views/app.vue", <<-VUE.strip_heredoc
    <template>
      <section v-if="protositeLoading" class="loading">loading...</section>
      <section v-else class="application">
        <h1>Protosite Demo</h1>
        <nav>
          <navigation :pages="protositePages" depth="5"/>
        </nav>
        <section class="content">
          <transition name="page">
            <router-view :key="protositePage.slug"/>
          </transition>
        </section>
      </section>
    </template>

    <script>
      import Navigation from 'components/navigation'

      export default {
        name: 'App',
        components: {Navigation},
      }
    </script>
  VUE

  file "app/javascript/views/home.vue", <<-VUE.strip_heredoc
    <template>
      <section class="home">
        <slot name="protosite" :schema="schema"/>
        <h1>{{protositePage.title}}</h1>
        <div :style="{backgroundColor: protositePage.data.color}">
          <h2>here's some custom content for the home page</h2>
          <slot name="components"/>
        </div>
        <ul>
          <li v-for="page in protositePage.pages" :key="page.id">
            <router-link :to="page.path">{{page.data.title}} - {{page.description || 'No description'}}</router-link>
          </li>
        </ul>
      </section>
    </template>

    <script>
      import {PAGE_PROPERTIES} from "@protosite/vue-protosite"

      export default {
        name: 'Home',
        data() {
          return {schema}
        },
        methods: {
          // You can add custom persistence logic for your page
          //persistPage() {},
        },
      }

      const schema = {
        type: 'object',
        required: ['title'],
        properties: Object.assign(PAGE_PROPERTIES, {
          color: {
            type: 'string',
            title: 'Color',
            attrs: {
              type: 'color',
            },
          },
        }),
      }
    </script>
  VUE

  file "app/javascript/components/hero.vue", <<-VUE.strip_heredoc
    <template>
      <article class="hero" :class="data.style">
        <h1>{{data.title}}</h1>
        <p>{{data.text}}</p>
        <slot name="protosite" :schema="schema"/>
      </article>
    </template>

    <script>
      export default {
        name: 'Hero',
        props: ['data'],
        data() {
          return {schema}
        },
      }

      const schema = {
        type: 'object',
        required: ['title', 'style'],
        properties: {
          title: {
            type: 'string',
            title: 'Title',
            default: 'Default title',
            minLength: 8,
            maxLength: 20,
            attrs: {
              placeholder: 'Enter the hero title here',
            },
          },
          text: {
            type: 'string',
            title: 'Text',
            maxLength: 800,
            attrs: {
              type: 'textarea',
            },
          },
          style: {
            type: 'string',
            title: 'Style',
            default: 'default',
            enum: ['default', 'fifty-fifty'],
            attrs: {
              // placeholder: 'Select a style...',
              type: 'radio',
            },
          },
        },
      }
    </script>

    <style scoped lang="scss">
      article.hero {
        min-height: 50px;

        &.fifty-fifty {
          display: grid;
          grid-template-columns: 1fr 2fr;
        }
      }
    </style>
  VUE

  file "app/javascript/components/navigation.vue", <<-VUE.strip_heredoc
    <template>
      <ul>
        <li v-for="p in pages" :key="p.id" v-if="p.parent || p.slug === ''">
          <router-link :to="p.path">{{p.data.title}}</router-link>
          <navigation :pages="p.pages" :depth="depth - 1" v-if="depth >= 2"/>
        </li>
      </ul>
    </template>

    <script>
      import Navigation from 'components/navigation'

      export default {
        name: 'Navigation',
        components: {Navigation},
        props: ['pages', 'depth'],
      }
    </script>
  VUE

  say "Getting database setup for Protosite"
  rails_command "protosite:install:migrations"
  rails_command "db:migrate"

  say "Protosite is now installed 🎉", :green
end
