<template>
  <component ref="component" :is="resolveTemplate(page)">
    <template slot="protosite" slot-scope="{schema}">
      <protosite-headful :title="page.title" :description="page.description"/>
      <protosite-toolbar :schema="schema" @persist="persistPage" v-if="can('edit')"/>
    </template>
    <template slot="components">
      <component v-for="c in page.components" :key="c.id" :is="resolveComponent(c)" :data="c">
        <template slot="protosite" slot-scope="{schema}">
          <protosite-controls :schema="schema" :data="c" @persist="persistComponent" v-if="page.editing && can('edit')"/>
        </template>
      </component>
    </template>
  </component>
</template>

<script>
  export default {
    name: 'Resolver',
    methods: {
      persistPage(e) {
        this.$refs['component'].persistPage()
      },
      persistComponent(e, data, mutableData) {
        this.$refs['component'].persistComponent(data, mutableData)
      },

      resolveTemplate(page) {
        return 'div'
      },

      resolveComponent(component) {
        return 'div'
      }
    },
  }
</script>
