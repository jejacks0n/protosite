import {sync} from 'vuex-router-sync'

import {Resolver, Missing, Headful, Page} from './components'
import {STORE} from './store'
import {Logger} from './logger'
import {Interface} from './interface'

let Vue, config, opts

class Instance {
  constructor({ store, router }) {
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
      storeModule: STORE,
      logger: Logger.log,
      resolver: null,
    }, config, options)

    this.instance = new Instance({ store: opts.store, router: opts.router })
    Vue.prototype['$protosite'] = this.instance

    this.installComponents()
    this.installToStore()
    this.installToRouter()
    this.installMixins()
    this.installInterface()
  }

  installComponents() {
    opts.logger('Adding components for rendering.')

    Vue.component('protosite-headful', Headful)
    Vue.component('protosite-resolver', opts.resolverComponent)
    Vue.component('protosite-page', opts.pageComponent)
    Vue.component('protosite-toolbar', { render: () => '' })
  }

  installToStore() {
    opts.logger('Registering the store module.')

    if (opts.store.registerModule) {
      opts.store.registerModule('protosite', opts.storeModule)
      opts.store.dispatch('protosite/setPages', opts.store.state.data.pages)
    } else {
      Logger.error('There was no way to register with the store, did you provide one in configuration or options?')
      throw new Error('Protosite: Unable to use provided store')
    }
  }

  installToRouter() {
    opts.logger('Building and adding routes.')

    opts.router.addRoutes(this.buildRoutesFor(opts.store.state.protosite.pages))
    opts.router.beforeEach((to, from, next) => {
      let page = (to.meta && to.meta.page)
      to.meta.page = page = (typeof page === 'string') ? opts.store.getters['protosite/findPage'](page) : page
      opts.logger('Setting page:', page)
      opts.store.commit('protosite/currentPage', page)
      next()
    })
  }

  installMixins() {
    opts.logger('Installing base mixins.')

    Vue.mixin({
      computed: {
        page: {
          get: () => opts.store.state.protosite.currentPage,
          set: (value) => opts.store.commit('currentPage', value, { module: 'protosite' }),
        },
      },
      methods: {
        resolve(object, objectType) {
          if (!object) return 'div'
          const type = object.type || (object.data ? object.data.type : null)
          const resolver = opts.resolver || opts.store.state.resolver
          const fallback = (objectType === 'page') ? opts.pageComponent : opts.missingComponent
          return resolver[type] || resolver[`default-${objectType}-type`] || fallback
        },
      },
    })
  }

  installInterface() {
    if (!opts.store.state.data.currentUser) return
    opts.logger('Installing toolbar interface.')

    if (opts.interface) {
      opts.interface(Vue, opts)
    } else if (typeof document !== 'undefined' && opts.store.state.data.protositePackSrc) {
      var s = document.createElement('script')
      s.type = 'text/javascript'
      s.onload = () => Protosite(Vue, opts)
      s.src = opts.store.state.data.protositePackSrc
      document.head.appendChild(s)
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
        meta: { page: page },
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
export {Instance, Interface, Resolver, Page, Headful}
