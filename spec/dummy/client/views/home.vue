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
  import {PAGE_PROPERTIES} from "@protosite/vue-protosite"

  export default {
    name: 'Home',
    data() {
      return {schema}
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
    ui: [
      {
        component: 'input',
        model: 'title',
        fieldOptions: {
          class: ['form-control'],
          on: ['input'],
          attrs: {
            placeholder: 'Enter the page title here',
          },
        },
      }
    ]
  }
</script>
