import shortid from 'shortid'

export const STORE = {
  state: {
    currentUser: null,
    currentPage: null,
    pages: [],
  },
  actions: {
    addPage({ commit }, text) {

      commit('addPage', { text, done: false })
    },
    removePage({ commit }, todo) {
      commit('removeTodo', todo)
    },
    editPage({ commit }, { todo, value }) {
      commit('editPage', { todo, text: value })
    },
    // clearCompleted({ state, commit }) {
    //   state.todos.filter(todo => todo.done)
    //     .forEach(todo => {
    //       commit('removeTodo', todo)
    //     })
    // },
  },
  mutations: {
    currentUser: (state, currentUser) => state.currentUser = currentUser,
    currentPage: (state, currentPage) => state.currentPage = currentPage,

    addPage(state, page) {
      // TODO: create on server, then
      state.pages.push(page)
    },

    removePage(state, page) {
      // TODO: remove from server, then
      state.pages.splice(state.pages.indexOf(page), 1)
    },

    editPage(state, { page, options = {} }) {
      for (let key of options) {
        page[key] = options[key]
      }
    },

    // addPage: (state, page, parent, index) => {
    //   page.id = page.id || shortid.generate()
    //   page.path = page.path || [(parent && parent.path), page.slug].join('/')
    //   page.position = index
    //   page.children_ids = page.children_ids || []
    //   if (parent) {
    //     page.parent_id = parent.id
    //     if (parent.children_ids.indexOf(page.id) < 0) {
    //       parent.children_ids.push(page.id)
    //     }
    //   }
    //   const existingPage = state.getters.findPage(page.id)
    //   if (existingPage) {
    //     state.commit('updatePage', page)
    //   } else {
    //     state.pages.push(page)
    //   }
    // },
    // updatePage: (state, page) => {
    //   state.pages.index(page => page.id === id)
    //   existingPage = page
    // },
  },
  getters: {
    findPage: (state) => (id) => {
      return state.pages.find(page => page.id === id)
    },
  },
}
