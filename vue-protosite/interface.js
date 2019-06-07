import VueFormJsonSchema from 'vue-form-json-schema';

import {GlobalToolbar, PageToolbar, ComponentToolbar} from './components/toolbars'

function Interface(Vue, options) {
  Installer.install(Vue, options)
  return new Installer(options)
}

let Vue, config, opts

class Installer {
  static install(V, c = {}) {
    c.logger('Installing Protosite interface.')
    Vue = V
    config = c
  }

  constructor(options) {
    opts = Object.assign({
      globalToolbarComponent: GlobalToolbar,
      pageToolbarComponent: PageToolbar,
      componentToolbarComponent: ComponentToolbar,
    }, config, options)

    // Install Protosite at various levels.
    this.installComponents()
    this.installMixins()

    // Put the global toolbar on the page.
    this.injectInterface()

    // Resolve that the interface is fully installed.
    opts.store.dispatch('protosite/resolved', 'interface')
  }

  installComponents() {
    Vue.component('protosite-global-toolbar', opts.globalToolbarComponent)
    Vue.component('protosite-page-toolbar', opts.pageToolbarComponent)
    Vue.component('protosite-component-toolbar', opts.componentToolbarComponent)

    Vue.component('protosite-component-form', VueFormJsonSchema);
    Vue.component('protosite-page-form', VueFormJsonSchema);
  }

  installMixins() {
    Vue.mixin({})
  }

  injectInterface() {
    const instance = new (Vue.extend({}))(opts.globalToolbarComponent).$mount()
    document.querySelector('body').appendChild(instance.$el)
  }
}

export default Installer
export {
  Interface,

  // Components.
  GlobalToolbar,
  PageToolbar,
  ComponentToolbar,

  // Constants.
}
