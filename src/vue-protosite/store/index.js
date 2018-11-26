export const STORE = {
  state: {
    currentUser: null,
    currentPage: null,
    pages: [],
  },
  actions: {
    setPages: ({ commit }, array) => commit('setPages', array)
  },
  mutations: {
    currentUser: (state, currentUser) => state.currentUser = currentUser,
    currentPage: (state, currentPage) => state.currentPage = currentPage,
    setPages: (state, pages) => state.pages = pages,
  },
  getters: {
    findPage: (state) => (id) => state.pages.find(page => page.id === id),
  },
}
