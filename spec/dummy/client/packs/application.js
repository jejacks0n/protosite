import 'styles/application.scss'
import Vue from 'vue/dist/vue.js'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueProtosite from '@legwork/vue-protosite'

import App from 'views/app'
import Work from 'views/work'
import Hero from 'components/hero'

// tell vue what to care about
Vue.use(Vuex)
Vue.use(VueRouter)
Vue.use(VueProtosite)

// setup vuex
const store = new Vuex.Store({
  state: {
    pages: window.data.pages,
    resolver: {
      'work-template': Work,
      'hero': Hero,
    },
  },
})

// setup the router
const router = new VueRouter({
  mode: 'history',
  fallback: false,
  routes: [
    { path: '*', page: 'error_404' },
  ],
})

// setup protosite
const protosite = new VueProtosite({ store, router, logger: () => null })

// render the app to the page
document.addEventListener('DOMContentLoaded', () => {
  new Vue({ store, router, protosite, el: '#root', components: { App } })
})
