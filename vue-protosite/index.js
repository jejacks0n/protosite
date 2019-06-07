import {sync} from 'vuex-router-sync'

import {Head, Page, Resolver, Fallback} from './components'
import {STORE_MODULE, GRAPHQL_QUERIES, PAGE_PROPERTIES} from './store'
import {Logger} from './logger'

let Vue, config, opts, state
let refTable = {}

class Instance {
  constructor({store, router}) {
    this.store = store
    this.router = router
    this.state = store.state.protosite
    this.resolver = store.state.resolver

    if (store && router) sync(store, router)
  }

  resolve(object) {
    if (!object) return 'div'
    const [struct, type] = this.types(object)
    object.id = object.id || this.reference(object)
    return this.resolver[type] || this.resolver[`default-${struct}-type`] || this.fallback(struct)
  }

  log(...messages) {
    opts.logger(...messages)
  }

  types(object) {
    return [
      object.path !== undefined || object.parent !== undefined ? 'page' : 'component', // struct
      object.type || (object.data ? object.data.type : 'default'), // declared type
    ]
  }

  fallback(struct) {
    return (struct === 'page' ? opts.pageComponent : opts.fallbackComponent)
  }

  reference(object) {
    const key = JSON.stringify(object)
    if (refTable[key]) return refTable[key]

    const a = (Math.random() * 46656) | 0, b = (Math.random() * 46656) | 0
    refTable[key] = ("000" + a.toString(36)).slice(-3) + ("000" + b.toString(36)).slice(-3)
    return refTable[key]
  }

  setPage(source) {
    let meta = source.meta || source
    let page = (meta && meta.page) || meta
    opts.store.commit('protosite/page', opts.store.getters['protosite/findPage'](page))
  }
}

class Installer {
  static install(V, c = {}) {
    Logger.log('Installing...')
    Vue = V
    config = c
  }

  constructor(options) {
    opts = Object.assign({
      store: null, // required
      router: null, // recommended

      // Customize behavior.
      storeModule: STORE_MODULE,
      logger: Logger.log,
      catchAllRoute: {path: '*', meta: {page: 'error_404'}},

      // Customize components.
      headComponent: Head,
      pageComponent: Page,
      resolverComponent: Resolver,
      fallbackComponent: Fallback,
    }, config, options)

    // Ensure required options are present.
    if (!opts.store) {
      Logger.error('You must provide a store.')
      throw new Error('Protosite: Unable to use provided store')
    }

    // Setup state so we can access it cleanly.
    state = opts.store.state
    state.data = state.data || {}
    state.data.currentUser = state.data.currentUser || null

    // Default more complex options.
    if (opts.catchAllRoute && !opts.catchAllRoute.component) {
      opts.catchAllRoute.component = opts.resolverComponent
    }

    // Install Protosite at various levels.
    this.installToStore()
    this.installComponents()
    this.installMixins()
    this.installInterface()

    // Instantiate the protosite instance (with limited access to objects) and
    // provide access to it via this.$protosite within components.
    this.instance = new Instance({store: opts.store, router: opts.router})
    Vue.prototype['$protosite'] = this.instance
  }

  installToStore() {
    opts.logger('Registering the store module.')

    if (opts.store.registerModule) {
      opts.store.registerModule('protosite', opts.storeModule)
      opts.store.dispatch('protosite/resolvePages', state.data).then(() => {
        this.addRoutes()
      })
    } else {
      Logger.error('There was no way to register with the store, did you provide a valid store?')
      throw new Error('Protosite: Unable to use provided store')
    }
  }

  installComponents() {
    opts.logger('Adding components for rendering.')

    // Rendering components.
    Vue.component('protosite-head', opts.headComponent)
    Vue.component('protosite-page', opts.pageComponent)
    Vue.component('protosite-resolver', opts.resolverComponent)
    Vue.component('protosite-fallback', opts.fallbackComponent)

    // Placeholder components.
    Vue.component('protosite-global-toolbar', {render: () => ''})
    Vue.component('protosite-page-toolbar', {render: () => ''})
    Vue.component('protosite-component-toolbar', {render: () => ''})
  }

  installMixins() {
    opts.logger('Installing base mixins.')

    Vue.mixin({
      computed: {
        currentUser: {
          get: () => state.protosite.currentUser,
        },
        page: {
          get: () => state.protosite.page,
          set: (value) => opts.store.commit('page', value, {module: 'protosite'}),
        },
      },
    })
  }

  installInterface() {
    opts.store.dispatch('protosite/resolveCurrentUser', state.data).then(() => {
      const pack = state.protosite.currentUser ? state.protosite.currentUser.pack : null
      if (pack) {
        if (typeof document !== 'undefined') {
          var script = document.createElement('script')
          script.onload = () => Protosite(Vue, opts)
          script.type = 'text/javascript'
          script.src = pack
          document.head.appendChild(script)
        }
      } else {
        opts.store.dispatch('protosite/resolved', 'interface')
      }
    })
  }

  addRoutes() {
    if (opts.router.addRoutes) {
      opts.logger('Building and adding routes.')

      let routes = this.buildRoutesFor(state.protosite.pages)
      if (opts.catchAllRoute) routes.push(opts.catchAllRoute)

      opts.router.addRoutes(routes)

      opts.router.beforeEach((to, from, next) => {
        this.instance.setPage(to)
        next()
      })

      opts.router.onReady(() => {
        if (!state.data.pages) { // force resolving the page for the initial load
          this.instance.setPage(opts.router.app.$route || opts.router.history.current)
        }
      })
    }

    opts.store.dispatch('protosite/resolved', 'routes')
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
}

export default Installer
export {
  Instance,

  // Components.
  Head,
  Page,
  Resolver,
  Fallback,

  // Constants.
  STORE_MODULE,
  GRAPHQL_QUERIES,
  PAGE_PROPERTIES,
}
