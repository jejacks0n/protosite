import {Toolbar, Controls} from './components/interface'

export function Interface(Vue, opts) {
  Vue.component('protosite-toolbar', Toolbar)
  Vue.component('protosite-controls', Controls)

  opts.logger('Rendering interface.')

  const Interface = Vue.extend({})
  const instance = new Interface({
    template: '<div>{{txt}}</div>',
    data: function() {
      return {
        txt: '[global interface]',
      }
    },
  })
  instance.$mount()
  if (typeof document !== 'undefined') document.querySelector('body').appendChild(instance.$el)
}

export {
  Toolbar,
  Controls,
  // constants
}
