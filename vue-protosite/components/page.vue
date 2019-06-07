<template>
  <section class="page" :class="[page.id, data.type]">
    <h1>{{data.title}}</h1>
    <slot name="protosite" :schema="schema"/>
    <slot name="components"/>
  </section>
</template>

<script>
  import {PAGE_PROPERTIES} from "../store"

  export default {
    name: 'Page',
    props: ['data'],
    data() {
      return {schema}
    },
  }

  const schema = {
    type: 'object',
    required: ['title'],
    properties: PAGE_PROPERTIES,
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
      },
    ]
  }
</script>
