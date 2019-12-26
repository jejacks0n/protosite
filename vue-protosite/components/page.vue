<template>
  <section class="page" :class="[page.id, data.type]">
    <h1>{{data.title}}</h1>
    <slot name="protosite" :schema="schema"/>
    <slot name="components"/>
  </section>
</template>

<script>
  import {PAGE_SCHEMA as schema} from '../store'

  export default {
    name: 'Page',
    props: ['data'],
    data() {
      return {schema}
    },
  }
</script>
