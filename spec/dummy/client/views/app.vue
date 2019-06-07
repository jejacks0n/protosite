<template>
  <section v-if="$protosite.state.loading" class="loading">loading...</section>
  <section v-else class="application">
    <h1>Protosite Demo</h1>
    <nav>
      <navigation :pages="$protosite.state.pages" depth="5"/>
    </nav>
    <section class="content">
      <transition name="page">
        <router-view :key="page.slug"/>
      </transition>
    </section>
  </section>
</template>

<script>
  import Navigation from 'components/navigation'

  export default {
    name: 'App',
    components: {Navigation},
  }
</script>
