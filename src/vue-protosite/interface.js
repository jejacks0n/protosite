export default function(Vue) {
  const Interface = Vue.extend({})
  new Interface({
    template: '<div>{txt}</div>',
    data: function() {
      return {
        txt: 'This is the toolbar',
      }
    },
    mounted() {
      console.log('toolbar is being rendered')
    },
  }).$mount().$appendTo('body')
}
