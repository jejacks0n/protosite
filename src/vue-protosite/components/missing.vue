<template>
  <article class="missing missing-component">
    <div>
      <strong>Missing Component {{data.type}}</strong>
    </div>
    <div class="data">{{JSON.stringify(data || '{}')}}</div>
    <slot name="protosite" :schema="schema"/>
  </article>
</template>

<script>
  export default {
    name: 'Missing',
    props: ['data'],
    data() {
      return {schema}
    },
  }

  const schema = {
    type: 'object',
    required: ['type'],
    properties: {
      type: {
        type: 'string',
      },
    },
  }
</script>

<style scoped lang="scss">
  article.missing-component {
    background: #f00;
    border: 1px solid #000;
    outline: 1px solid #000;
    color: #fff;

    div.data {
      font-family: monospace;
      color: #fff;
      overflow-x: scroll;
      max-height: 3em;
      white-space: nowrap;
    }
  }
</style>
