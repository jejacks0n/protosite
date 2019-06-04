<template>
  <section v-if="protositeLoading" class="loading">loading...</section>
  <section v-else class="application">
    <h1>Protosite Demo</h1>
    <nav>
      <navigation :pages="protositePages" depth="5"/>
    </nav>
    <section class="content">
      <transition name="page">
        <router-view :key="protositePage.slug"/>
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
