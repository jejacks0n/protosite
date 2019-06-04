import ApolloClient from 'apollo-boost'
import gql from 'graphql-tag'
import {Logger} from './logger'

const client = new ApolloClient({uri: '/protosite'})
const flatten = (pages) => pages.reduce((acc, page) => acc.concat(flatten(page.pages || [])), pages)
const resolveApi = (commit, data, prop) => {
  if (data && data[prop]) return commit(prop, data[prop])
  return client.query({query: GRAPHQL_QUERIES[prop]})
    .then(({data}) => commit(prop, data[prop]))
    .catch((error) => Logger.error(error))
}

export const GRAPHQL_QUERIES = {
  currentUser: gql`
    query CurrentUser {
      currentUser {id, email, name, pack, permissions}
    }`,
  pages: gql`
    query Pages {
      pages {id, slug, data, pages {id, slug, data, pages {id, slug, data, pages {id, slug, data, pages {id, slug, data}}}}}
    }`,
}

export const STORE_MODULE = {
  namespaced: true,
  state: {
    loading: true,
    currentUser: null,
    page: null,
    pages: [],
    pagesFlat: [],
  },
  actions: {
    resolveCurrentUser({commit}, data) {
      return resolveApi(commit, data, 'currentUser')
    },
    resolvePages({commit}, data) {
      return resolveApi(commit, data, 'pages')
    },
  },
  mutations: {
    loaded(state) {
      state.loading = false
    },
    currentUser(state, currentUser) {
      state.currentUser = currentUser
    },
    page(state, page) {
      state.page = page
    },
    pages(state, pages) {
      state.pages = pages
      state.pagesFlat = flatten(pages)
    },
  },
  getters: {
    findPage(state) {
      return (id) => state.pagesFlat.find(page => page.id === id)
    },
  },
}

export const PAGE_PROPERTIES = {
  title: {
    type: 'string',
    title: 'Page title',
    maxLength: 50,
  },
  slug: {
    type: 'string',
    title: 'Slug title',
    help: 'The slug will determine the path at which this page is accessible. Leave blank to default from the title. Allowed characters are letters, numbers and dashes.',
    maxLength: 100,
    pattern: "[0-9A-Za-z-]",
  },
  description: {
    type: 'string',
    title: 'Meta description',
    maxLength: 800,
    attrs: {
      type: 'textarea',
    },
  },
}
