import {Resolver, Headful, Page} from './components'
import {STORE} from './store'
import {Logger} from './logger'
import {Interface} from './interface'

let Vue, config, opts

class Instance {
  constructor({ store, router }) {
    this.store = store
    this.router = router
  }
}

class Installer {
  constructor(options) {
    opts = Object.assign({
      store: null, // required
      router: null, // recommended
      resolverComponent: Resolver,
      pageComponent: Page,
      storeModule: STORE,
      logger: Logger.log
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
    Vue.component('protosite-toolbar', {render: () => ''})
  }

  installToStore() {
    opts.logger('Registering the store module.')

    if (opts.store.registerModule) {
      opts.store.registerModule('protosite', opts.storeModule)
      opts.store.dispatch('protosite/setPages', opts.store.state.pages)
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
      page = (typeof page === 'string') ? opts.store.getters['protosite/findPage'](page) : page
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
        resolve(object) {
          const resolver = opts.store.state.resolver
          if (object.data) {
            return resolver[object.data.type] || resolver['default-template'] || opts.pageComponent
          } else {
            return resolver[object.type] || resolver['default-type'] || 'div'
          }
        }
      }
    })
  }

  installInterface() {
    if (!window.data.currentUser) return
    opts.logger('Installing toolbar interface.')

    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.onload = () => window.Protosite(Vue, opts)
    s.src = window.data.protositePackSrc;
    document.head.appendChild(s);
  }

  buildRoutesFor(array, parent = null) {
    let routes = []
    if (!array) return routes
    for (const page of array) {
      page.path = !parent ? `/${page.slug}` : [parent.path, page.slug].join('/').replace(/\/+/ig, '/')
      page.parent = parent
      routes.push({
        path: !parent ? `/${page.slug}` : page.slug,
        component: opts.resolverComponent,
        children: this.buildRoutesFor(page.pages, page),
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
