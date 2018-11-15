<template>
  <section class="work">
    <slot name="protosite" :schema="schema"/>
    <h1>{{page.title}}</h1>
    <h2 :style="{backgroundColor: page.color}">here's some custom stuff, with a link to a [<a href="/borken">broken page</a>]</h2>
    <ul>
      <li v-for="child in page.children" :key="child.id">
        <router-link :to="child.fullPath">{{child.title}} - {{child.description}}</router-link>
      </li>
    </ul>
  </section>
</template>

<script>
  export default {
    name: 'Work',
    data() {
      return { schema }
    },
    methods: {
      persistPage() {
        //
      }
    }
  }

  const schema = {
    type: 'object',
    required: ['title'],
    properties: {
      title: {
        type: 'string',
        title: 'Page title',
        maxLength: 50,
      },
      description: {
        type: 'string',
        title: 'Meta description',
        maxLength: 800,
        attrs: {
          type: 'textarea',
        },
      },
      color: {
        type: 'string',
        title: 'Color',
        attrs: {
          type: 'color',
        },
      },
    },
  }
</script>

<style scoped lang="scss">
</style>
