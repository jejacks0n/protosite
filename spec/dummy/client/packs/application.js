import 'styles/application.scss'
import Vue from 'vue/dist/vue.js'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueProtosite from '@legwork/vue-protosite'

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
    data: window.data,
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
// toolbarPack: 'custom_toolbar'
//
// If a user is signed in with the correct access privileges, the protosite
// toolbar will be presented to the user.
const protosite = new VueProtosite({ store, router, logger: () => null })

// Render the app to the page.
document.addEventListener('DOMContentLoaded', () => {
  new Vue({ store, router, protosite, el: '#root', components: { App } })
})
