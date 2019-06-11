<template>
  <component :is="$protosite.resolve(page)" :key="page.id" :ref="page.id" :data="page.data">
    <template slot="protosite" slot-scope="{schema}">
      <protosite-head :data="page.data"/>
      <protosite-page-toolbar v-model="page.data" :schema="schema" @persist="persist(page)"/>
    </template>
    <template slot="components">
      <component v-for="c in components" :is="$protosite.resolve(c)" :key="c.id" :ref="c.id" :data="c.data">
        <template slot="protosite" slot-scope="{schema}">
          <protosite-component-toolbar v-model="c.data" :schema="schema" @persist="persist(c)"/>
        </template>
      </component>
    </template>
  </component>
</template>

<script>
  export default {
    name: 'Resolver',
    computed: {
      components() {
        return this.page.data.components
      },
    },
    methods: {
      persist(object) {
        this.$protosite.log('Persisting...', object)

        let ref = this.$refs[object.id]
        if (Array.isArray(ref)) ref = ref[0]

        ref.beforePersist && ref.beforePersist(object)
        ref.persist && ref.persist(object)
      },
    },
  }
</script>
