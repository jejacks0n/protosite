import {GlobalToolbar, PageToolbar, ComponentToolbar} from './components/toolbars'

export function Interface(Vue, opts) {
  Vue.component('protosite-page-toolbar', PageToolbar)
  Vue.component('protosite-component-toolbar', ComponentToolbar)

  opts.logger('Rendering toolbar interface.')

  const instance = new (Vue.extend({}))(GlobalToolbar).$mount()
  document.querySelector('body').appendChild(instance.$el)
}

export {
  GlobalToolbar,
  PageToolbar,
  ComponentToolbar,
  // constants
}
