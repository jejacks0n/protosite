<template>
  <ul>
    <li v-for="p in pages" :key="p.id" v-if="p.parent || p.slug === ''">
      <router-link :to="p.path">{{p.data.title}}</router-link>
      <navigation :pages="p.pages" :depth="depth - 1" v-if="depth >= 2"/>
    </li>
  </ul>
</template>

<script>
  import Navigation from 'components/navigation'

  export default {
    name: 'Navigation',
    components: { Navigation },
    props: ['pages', 'depth']
  }
</script>

<style scoped lang="scss">
</style>
