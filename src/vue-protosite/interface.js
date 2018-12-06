export function Interface(Vue, opts) {
  opts.logger('Rendering toolbar interface.')

  const Interface = Vue.extend({})
  const instance = new Interface({
    template: '<div>{{txt}}</div>',
    data: function() {
      return {
        txt: 'This is the toolbar',
      }
    },
  })
  instance.$mount()
  if (typeof document !== 'undefined') document.querySelector('body').appendChild(instance.$el)
}
