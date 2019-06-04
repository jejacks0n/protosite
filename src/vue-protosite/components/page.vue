<template>
  <section class="page" :class="[protositePage.id, protositePage.data.type]">
    <h1>{{protositePage.data.title}}</h1>
    <slot name="protosite" :schema="schema"/>
    <slot name="components"/>
  </section>
</template>

<script>
  import {PAGE_PROPERTIES} from "../store"

  export default {
    name: 'Page',
    data() {
      return {schema}
    },
  }

  const schema = {
    type: 'object',
    required: ['title'],
    properties: PAGE_PROPERTIES,
  }
</script>
