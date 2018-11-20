import {Resolver, Headful, Page} from './components'
import {STORE} from './store'
import {Logger} from './logger'

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
      // required
      store: null,
      // optional, for page route handling
      router: null,
      // optional, for component overrides
      resolverComponent: Resolver,
      pageComponent: Page,
      toolbarComponent: Toolbar,
      // optional, for completely overriding the store
      // to do this, you need to match the interface
      // that protosite is expecting
      storeModule: STORE
    }, config, options)

    this.installComponents()
    this.installToStore()
    // this.installToRouter()
    // this.installMixins()

    Vue.prototype['$protosite'] = new Instance({ store: opts.store, router: opts.router })
  }

  installComponents() {
    // expose vue-headful protosite-headful for consistency
    Vue.component('protosite-headful', Headful)

    // expose the resolver and page components for flexibility later
    Vue.component('protosite-resolver', opts.resolverComponent)
    Vue.component('protosite-page', opts.pageComponent)

    // expose the toolbar, which can be completely overridden if needed
    Vue.component('protosite-toolbar', opts.toolbarComponent)
  }

  installToStore() {
    if (opts.store.registerModule) {
      opts.store.registerModule('protosite', opts.storeModule)
    } else {
      Logger.error('There was no way to register with the store, did you provide one in configuration or options?')
      throw new Error('Protosite: Unable to use provided store')
    }
  }

  installToRouter() {
    // TODO: Huge! need to figure out how we're going to try to load pages
    opts.router.addRoutes(this.buildRoutesFor(opts.store.protosite.pages))
    opts.router.beforeEach((to, from, next) => {
      let page = (to.meta && to.meta.page) // TODO: resolve page from page id if that's all we've got
      opts.store.commit('currentPage', page, { module: 'protosite' })
      next()
    })
  }

  buildRoutesFor(array, parent) {
    let routes = []
    if (!array) return routes
    for (const i of array) {
      const page = array[i]
      opts.store.commit('addPage', page, parent, i + 1, { module: 'protosite' })
      routes.push({
        path: parent ? page.slug : page.path,
        component: opts.resolverComponent,
        children: this.buildRoutesFor(page.children, page),
        meta: { page: page },
      })
    }
    return routes
  }

  installMixins() {
    Vue.mixin({
      computed: {
        page: {
          get() {
            return opts.store.state.protosite.currentPage
          },
          set(value) {
            opts.store.commit('currentPage', value, { module: 'protosite' })
          },
        },
        currentUser() {
          return opts.store.state.protosite.currentUser
        },
      },
      methods: {
        persistPage() {
          this.$protosite.persistPage(this.page)
        },
        persistComponent(data, mutableData) {
          this.$protosite.persistComponent(this.page, data, mutableData)
        },
        resolveTemplate(page) {
          return opts.resolver[page.template] || opts.resolver['default-template'] || opts.pageComponent
        },
        resolveComponent(component) {
          return opts.resolver[component.type] || opts.resolver['default-component'] || 'div'
        },
        defaultsFromSchema(schema, extra) {
          let ret = {}
          for (let key of Object.keys(schema.properties)) {
            if (typeof schema.properties[key].default !== 'undefined') {
              ret[key] = schema.properties[key].default
            }
          }
          console.log(ret)

          return Object.assign(ret, extra)
        },
        can(action, options = {}) {
          return true
          // const user = options.user || this.currentUser
          // return user.permissions['admin'] || user.permissions[action]
        },
      },
    })
  }

  persistPage(page) {
    this.resolvePage(page, opts.store.state.pages)
    opts.store.commit('pages', opts.store.state.pages)
  }

  persistComponent(page, data, mutableData) {
    this.resolveComponent(page, data, mutableData)
    this.persistPage(page)
  }

  resolvePage(page, array, depth = 0) {
    const paths = page.fullPath.split('/')
    for (const i in array) {
      if (paths[depth] === array[i].path) {
        if (paths[depth + 1] && array[i].children) {
          let x = this.resolvePage(page, array[i].children, depth + 1)
          if (!x) this.resolvePage(page, array, depth + 1)
        } else {
          this.replaceInArray(array, i, page)
          return true
        }
      }
    }
  }

  resolveComponent(page, data, updatedData) {
    let index = page.components.indexOf(data)
    this.replaceInArray(page.components, index, updatedData)
  }

  replaceInArray(array, index, replacement) {
    if (replacement === null) {
      array.splice(index, 1)
    } else {
      array.splice(index, 1, replacement)
    }
  }

  static install(V, c = {}) {
    Logger.log('Installing 123...')
    Vue = V
    config = c
  }
}

export default Installer
export {Instance}
