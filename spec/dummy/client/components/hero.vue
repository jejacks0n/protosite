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
    }
  }

  const schema = {
    type: 'object',
    required: ['title', 'style'],
    properties: {
      title: {
        type: 'string',
        title: 'Title',
        default: 'Default title',
        minLength: 8,
        maxLength: 20,
        attrs: {
          placeholder: 'Enter the hero title here',
        },
      },
      text: {
        type: 'string',
        title: 'Text',
        maxLength: 800,
        attrs: {
          type: 'textarea',
        },
      },
      style: {
        type: 'string',
        title: 'Style',
        default: 'default',
        enum: ['default', 'fifty-fifty'],
        attrs: {
          // placeholder: 'Select a style...',
          type: 'radio',
        },
      },
    },
    ui: [
      {
        component: 'input',
        model: 'title',
        fieldOptions: {
          class: ['form-control'],
          on: ['input'],
          attrs: {
            placeholder: 'Enter the hero title here',
          },
        },
      },
    ]
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
