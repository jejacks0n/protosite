<template>
  <section class="page">
    <h1>{{page.title}}</h1>
    <slot name="protosite" :schema="schema"/>
    <slot name="components"/>
  </section>
</template>

<script>
  export default {
    name: 'Page',
    data() {
      return {
        schema
      }
    },
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
    },
  }
</script>

<style scoped lang="scss">
</style>
