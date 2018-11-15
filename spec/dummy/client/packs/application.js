import 'styles/application.scss'
import Vue from 'vue/dist/vue.js'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueProtosite from '@legwork/vue-protosite'

import {STORE} from 'constants/store'
import {ROUTES} from 'constants/routes'

import App from 'views/app'

// tell vue what to care about
Vue.use(Vuex)
Vue.use(VueRouter)
Vue.use(VueProtosite)

// setup vuex
const store = new Vuex.Store(STORE)

// setup the router
const router = new VueRouter(ROUTES)

// setup protosite
const protosite = new VueProtosite({ store, router, importPages: store.state.pages })

// render the app to the page
document.addEventListener('DOMContentLoaded', () => {
  new Vue({ store, router, protosite, el: '#root', components: { App } })
})
