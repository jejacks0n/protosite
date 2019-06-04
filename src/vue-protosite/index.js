import {sync} from 'vuex-router-sync'

import {Resolver, Missing, Headful, Page} from './components'
import {STORE_MODULE, GRAPHQL_QUERIES, PAGE_PROPERTIES} from './store'
import {Logger} from './logger'
import {Interface} from './interface'

let Vue, config, opts, state

class Instance {
  constructor({store, router}) {
    this.store = store
    this.router = router

    if (store && router) sync(store, router)
  }
}

class Installer {
  constructor(options) {
    opts = Object.assign({
      store: null, // required
      router: null, // recommended
      resolverComponent: Resolver,
      pageComponent: Page,
      missingComponent: Missing,
      missingPage: null,
      storeModule: STORE_MODULE,
      logger: Logger.log,
      resolver: null,
    }, config, options)

    // Ensure required options are present.
    if (!opts.store) {
      Logger.error('You must provide a store.')
      throw new Error('Protosite: Unable to use provided store')
    }

    // Setup state so we can access it cleanly.
    state = opts.store.state
    state.data = state.data || {}

    // Instantiate the protosite instance (with limited access to objects) and
    // provide access to it via this.$protosite within components.
    this.instance = new Instance({store: opts.store, router: opts.router})
    Vue.prototype['$protosite'] = this.instance

    // Default more complex options.
    if (opts.missingPage === null) { // if no a catchall, use `false`.
      opts.missingPage = {path: '*', component: opts.resolverComponent, meta: {page: opts.missingPage}}
    }

    // Install Protosite at various levels.
    this.installToStore()
    this.installComponents()
    this.installInterface()
    this.installMixins()
  }

  installToStore() {
    opts.logger('Registering the store module.')

    if (opts.store.registerModule) {
      opts.store.registerModule('protosite', opts.storeModule)
      opts.store.dispatch('protosite/resolvePages', state.data).then(() => {
        this.addRoutes()
        opts.store.commit('protosite/loaded', true)
      })
    } else {
      Logger.error('There was no way to register with the store, did you provide a valid store?')
      throw new Error('Protosite: Unable to use provided store')
    }
  }

  installComponents() {
    opts.logger('Adding components for rendering.')

    Vue.component('protosite-headful', Headful)
    Vue.component('protosite-resolver', opts.resolverComponent)
    Vue.component('protosite-page', opts.pageComponent)
    Vue.component('protosite-toolbar', {render: () => ''})
  }

  installMixins() {
    opts.logger('Installing base mixins.')

    Vue.mixin({
      computed: {
        protositeLoading: {
          get() {
            return state.protosite.loading
          },
        },
        protositePages: {
          get() {
            return state.protosite.pages
          },
        },
        protositePage: {
          get() {
            return state.protosite.page
          },
          set(value) {
            return opts.store.commit('page', value, {module: 'protosite'})
          },
        },
        protositeHome: {
          get() {
            return opts.store.getters['protosite/findPage']('home')
          },
        },
      },
      methods: {
        resolve(object, objectType) {
          if (!object) return 'div'
          const type = object.type || (object.data ? object.data.type : null)
          const resolver = opts.resolver || state.resolver
          const fallback = (objectType === 'page') ? opts.pageComponent : opts.missingComponent
          return resolver[type] || resolver[`default-${objectType}-type`] || fallback
        },
      },
    })
  }

  installInterface() {
    opts.store.dispatch('protosite/resolveCurrentUser', state.data).then(() => {
      const pack = state.protosite.currentUser ? state.protosite.currentUser.pack : null
      if (!pack) return

      opts.logger('Installing Protosite interface.')

      if (opts.interface) {
        opts.interface(Vue, opts)
      } else if (typeof document !== 'undefined') {
        var s = document.createElement('script')
        s.type = 'text/javascript'
        s.onload = () => Protosite(Vue, opts)
        s.src = pack
        document.head.appendChild(s)
      }
    })
  }

  addRoutes() {
    if (!opts.router.addRoutes) return

    opts.logger('Building and adding routes.')

    let routes = this.buildRoutesFor(state.protosite.pages)
    if (opts.missingPage) {
      routes.push(opts.missingPage)
    }

    const resolvePage = (meta) => {
      let page = (meta && meta.page)
      meta.page = page = (typeof page === 'string') ? opts.store.getters['protosite/findPage'](page) : page

      const title = (page && page.data) ? page.data.title : null
      opts.logger('Setting page:', title || 'Unknown', page)
      opts.store.commit('protosite/page', page)
    }

    opts.router.addRoutes(routes)

    opts.router.beforeEach((to, from, next) => {
      resolvePage(to.meta)
      next()
    })

    if (!state.data.pages) { // force resolving the page for the initial load
      opts.router.onReady(() => {
        let meta = opts.router.app.$route ? opts.router.app.$route.meta : null
        meta = meta || opts.router.history.current.meta
        resolvePage(meta)
      })
    }
  }

  buildRoutesFor(array, parent = null) {
    let routes = []
    if (!array) return routes
    for (const page of array) {
      page.path = !parent ? `/${page.slug}` : [parent.path, page.slug].join('/').replace(/\/+/ig, '/')
      page.parent = parent ? parent.id : null
      routes.push({
        path: !parent ? `/${page.slug}` : page.slug,
        component: opts.resolverComponent,
        children: this.buildRoutesFor(page.pages, page),
        props: true,
        meta: {page: page},
      })
    }
    return routes
  }

  static install(V, c = {}) {
    Logger.log('Installing...')
    Vue = V
    config = c
  }
}

Installer.Resolver = Resolver
Installer.Page = Page
Installer.Headful = Headful

export default Installer
export {
  Instance,
  Interface,
  Resolver,
  Page,
  Headful,
  // constants
  STORE_MODULE,
  GRAPHQL_QUERIES,
  PAGE_PROPERTIES,
}
