<template>
  <section class="application">
    <h1>Protosite</h1>
    <nav>
      <router-link v-for="p in pages" :key="p.id" :to="'/' + p.path">{{p.title}}<br></router-link>
    </nav>
    <transition name="page">
      <router-view/>
    </transition>
  </section>
</template>

<script>
  import {mapState} from 'vuex'

  export default {
    name: 'App',
    computed: {
      ...mapState(['pages']),
    },
  }
</script>

<style scoped lang="scss">
</style>
