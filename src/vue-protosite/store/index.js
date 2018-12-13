const flatten = (pages) => pages.reduce((acc, page) => acc.concat(flatten(page.pages || [])), pages)

export const STORE = {
  namespaced: true,
  state: {
    currentUser: null,
    currentPage: null,
    pages: [],
    flat: [],
  },
  actions: {
    // TODO: if this is empty, we should assume we need to load pages via the api?
    setPages: ({ commit }, array) => commit('setPages', array),
  },
  mutations: {
    currentUser: (state, currentUser) => state.currentUser = currentUser,
    currentPage: (state, currentPage) => state.currentPage = currentPage,
    setPages: (state, pages) => {
      state.pages = pages
      state.flat = flatten(pages)
    },
  },
  getters: {
    findPage: (state) => (id) => state.flat.find(page => page.id === id),
  },
}
