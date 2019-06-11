<template>
  <section class="home">
    <h1>{{page.data.title}}</h1>
    <div :style="{backgroundColor: page.data.color}">
      <h2>here's some custom content for the home page</h2>
      <slot name="components"/>
    </div>
    <slot name="protosite" :schema="schema"/>
    <ul>
      <li v-for="page in page.pages" :key="page.id">
        <router-link :to="page.path">{{page.data.title}} - {{page.description || 'No description'}}</router-link>
      </li>
    </ul>
  </section>
</template>

<script>
  import {PAGE_SCHEMA, defaultsDeep} from "@protosite/vue-protosite"

  export default {
    name: 'Home',
    data() {
      return {schema}
    },
  }

  const schema = defaultsDeep(PAGE_SCHEMA, {
    type: 'object',
    required: ['title'],
    properties: {
      color: {
        type: 'string',
        title: 'Color',
        default: '#efefef',
        attrs: {
          type: 'color',
        },
      },
    },
  })
</script>
