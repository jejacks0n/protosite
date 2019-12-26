import ApolloClient from 'apollo-boost'
import gql from 'graphql-tag'

import {Logger} from './logger'

const client = new ApolloClient({uri: '/protosite'})

const flatten = (pages) => pages.reduce((acc, p) => acc.concat(flatten(p.pages || [])), pages)
const query = (query, r) => client.query({query: query}).then(({data}) => r(data)).catch((e) => Logger.error(e))
const resolve = (commit, d, p) => (d && d[p]) ? commit(p, d[p]) : query(GRAPHQL_QUERIES[p], (d) => commit(p, d[p]))

let resolvedItems = []
let flattenedPages = []

export const STORE_MODULE = {
  namespaced: true,
  state: {
    loading: true,
    currentUser: null,
    page: null,
    pages: [],
  },
  actions: {
    async resolveCurrentUser({commit, dispatch}, data) {
      if (data.currentUser !== null) { // don't check if not needed
        await resolve(commit, data, 'currentUser')
      }
      dispatch('resolved', 'currentUser')
    },
    async resolvePages({commit, dispatch}, data) {
      await resolve(commit, data, 'pages')
      dispatch('resolved', 'pages')
    },
    resolved({commit}, resolution) {
      resolvedItems.push(resolution)
      if (resolvedItems.length >= 4) commit('loaded')
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
      flattenedPages = flatten(pages)
    },
  },
  getters: {
    findPage: () => (id) => (typeof id === 'string') ? flattenedPages.find(p => p.id === id) : id,
  },
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

export const PAGE_SCHEMA = {
  type: 'object',
  required: ['title'],
  properties: {
    title: {
      type: 'string',
      title: 'Page title',
      maxLength: 50,
    },
    slug: {
      type: 'string',
      title: 'Slug title',
      maxLength: 100,
      pattern: '[0-9A-Za-z-]?',
      ui: {
        help: 'The slug is the path at which this page will be accessible. Leave blank to default it from the title.',
      },
    },
    description: {
      type: 'string',
      title: 'Meta description',
      maxLength: 800,
      ui: {
        component: 'textarea',
      },
    },
  },
}
