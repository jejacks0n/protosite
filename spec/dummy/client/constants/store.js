import Work from 'views/work'
import Hero from 'components/hero'

import createPersistedState from 'vuex-persistedstate'

export const STORE = {
  plugins: [createPersistedState({ key: 'protosite' })],
  state: {
    resolver: {
      'work-template': Work,
      'hero': Hero,
    },
    pages: [
      { id: 'error_404', slug: '404', title: '404' },
      {
        slug: '',
        title: 'Home',
        children: [
          {
            slug: 'work',
            title: 'Work',
            template: 'work-template',
            children: [
              {
                slug: 'hitman-2',
                title: 'Hitman 2',
              },
              {
                slug: 'it-can-wait',
                title: 'It Can Wait',
              },
            ],
          },
        ],
      },
    ],
  },
  mutations: {
    pages: (state, pages) => state.pages = pages,
  },
}
