<template>
  <section class="application">
    <h1>Protosite Demo</h1>
    <nav>
      <navigation :pages="pages" depth="5"/>
    </nav>
    <section class="content">
      <transition name="page">
        <router-view/>
      </transition>
    </section>
  </section>
</template>

<script>
  import {mapState} from 'vuex'
  import Navigation from 'components/navigation'

  export default {
    name: 'App',
    components: {Navigation},
    computed: {
      ...mapState(['pages']),
    },
  }
</script>
