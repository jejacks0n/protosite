<template>
  <section class="page">
    <h1>{{page.data.title}}</h1>
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
      slug: {
        type: 'string',
        title: 'Slug title',
        help: 'The slug will determine the path at which this page is accessible. Leave blank to default from the title. Allowed characters are letters, numbers and dashes.',
        maxLength: 100,
        pattern: "[0-9A-Za-z-]"
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
