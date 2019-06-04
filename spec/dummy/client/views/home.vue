<template>
  <section class="home">
    <slot name="protosite" :schema="schema"/>
    <h1>{{protositePage.title}}</h1>
    <div :style="{backgroundColor: protositePage.data.color}">
      <h2>here's some custom content for the home page</h2>
      <slot name="components"/>
    </div>
    <ul>
      <li v-for="page in protositePage.pages" :key="page.id">
        <router-link :to="page.path">{{page.data.title}} - {{page.description || 'No description'}}</router-link>
      </li>
    </ul>
  </section>
</template>

<script>
  import {PAGE_PROPERTIES} from "@protosite/vue-protosite"

  export default {
    name: 'Home',
    data() {
      return {schema}
    },
    methods: {
      // You can add custom persistence logic for your page
      //persistPage() {},
    },
  }

  const schema = {
    type: 'object',
    required: ['title'],
    properties: Object.assign(PAGE_PROPERTIES, {
      color: {
        type: 'string',
        title: 'Color',
        attrs: {
          type: 'color',
        },
      },
    }),
  }
</script>
