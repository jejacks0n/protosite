import VueFormJsonSchema from 'vue-form-json-schema'

import {GlobalToolbar, PageToolbar, ComponentToolbar} from './components/toolbars'

import {SchemaProcessor, UISCHEMA_DEFAULTS} from './schema'
import {Logger} from "./logger"

let Vue, config, opts

class Interface {
  static install(c = {}) {
    config = c
    return (...args) => new Interface(...args)
  }

  constructor(V, options) {
    Vue = V
    opts = Object.assign({
      // Customize behavior.
      schemaProcessor: null,
      schemaTypeDefaults: UISCHEMA_DEFAULTS,

      // Customize toolbar components.
      globalToolbarComponent: GlobalToolbar,
      pageToolbarComponent: PageToolbar,
      componentToolbarComponent: ComponentToolbar,

      // Customize input components.
      // inputComponent: Input,
    }, config, options)

    // Default more complex options.
    opts.schemaProcessor = opts.schemaProcessor || new SchemaProcessor(opts.schemaTypeDefaults)

    // Ensure required options are present.
    if (!opts.schemaProcessor || !opts.schemaProcessor.process) {
      Logger.error('You must provide a valid schemaProcessor.')
      throw new Error('Protosite: Unable to use provided schemaProcessor')
    }

    // Install Protosite at various levels.
    this.installComponents()
    this.extendProtosite()
    this.promptOnAbandon()

    // Put the global toolbar on the page.
    this.injectInterface()

    // Resolve that the interface is fully installed.
    opts.store.dispatch('protosite/resolved', 'interface')
  }

  installComponents() {
    Vue.component('protosite-global-toolbar', opts.globalToolbarComponent)
    Vue.component('protosite-page-toolbar', opts.pageToolbarComponent)
    Vue.component('protosite-component-toolbar', opts.componentToolbarComponent)

    Vue.component('protosite-form', VueFormJsonSchema)
  }

  extendProtosite() {
    Object.assign(Vue.prototype.$protosite, {
      extractUIFromSchema(schema) {
        return opts.schemaProcessor.process(schema)
      },
    })
  }

  promptOnAbandon() {
    // window.addEventListener('beforeunload', (e) => {
    //   e.preventDefault()
    //   e.returnValue = ''
    // })
  }

  injectInterface() {
    const instance = new (Vue.extend({}))(opts.globalToolbarComponent).$mount()
    document.querySelector('body').appendChild(instance.$el)
  }
}

export default Interface
export {
  // Components.
  GlobalToolbar,
  PageToolbar,
  ComponentToolbar,

  // Utility.
  SchemaProcessor,

  // Constants.
  UISCHEMA_DEFAULTS,
}
