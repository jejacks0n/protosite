<template>
  <article class="hero" :class="data.style">
    <h1>{{data.title}}</h1>
    <p>{{data.text}}</p>
    <slot name="protosite" :schema="schema"/>
  </article>
</template>

<script>
  export default {
    name: 'Hero',
    props: ['data'],
    data() {
      return {schema}
    },
    methods: {
      beforePersist(object) {
        console.log('beforePersist', object)
      },
      persist(object) {
        console.log('persist', object)
      },
    },
  }

  const schema = {
    type: 'object',
    required: ['title', 'style'],
    properties: {
      title: {
        type: 'string',
        title: 'Title',
        maxLength: 20,
        ui: {
          default: 'Default title',
          prompt: 'Enter the hero title here',
        },
      },
      text: {
        type: 'string',
        title: 'Text',
        maxLength: 800,
        ui: {
          component: 'textarea',
        },
      },
      style: {
        type: 'string',
        title: 'Style',
        enum: ['default', 'fifty-fifty'],
        ui: {
          default: 'default',
          prompt: 'Select a style...',
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  article.hero {
    min-height: 50px;

    &.fifty-fifty {
      display: grid;
      grid-template-columns: 1fr 2fr;
    }
  }
</style>
