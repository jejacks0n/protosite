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
// that handles 404s by rendering the error_404 page by default.
const router = new VueRouter({mode: 'history', fallback: false})

// Setup Protosite. Protosite requires the Vuex store and for the store to have
// a resolver object and optionally some data (to avoid a round trip to the api
// on initial load).
//
// If a user is signed in with the correct access privileges, the protosite.js
// pack will be loaded and presented to the user. The Protosite interface can
// be configured and modified in protosite.js.
const protosite = new VueProtosite({store, router})

// Render the app to the page.
document.addEventListener('DOMContentLoaded', () => {
  new Vue({store, router, protosite, el: '#root', components: {App}})
})
