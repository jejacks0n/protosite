<template>
  <headful :title="data.title" :description="data.description || data.title"/>
</template>

<script>
  import Headful from 'vue-headful'

  export default {
    name: 'Head',
    props: ['data'],
    components: {Headful},
  }
</script>
