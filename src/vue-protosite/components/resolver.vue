<template>
  <component ref="component" :is="resolve(protositePage, 'page')">
    <template slot="protosite" slot-scope="{schema}">
      <!--<protosite-headful :title="page.data.title" :description="page.data.description || page.data.title"/>-->
      <protosite-toolbar :schema="schema" @persist="persist"/>
    </template>
    <template slot="components">
      <component v-for="c in protositePage.data.components" :key="c.id" :is="resolve(c, 'component')" :data="c">
        <template slot="protosite" slot-scope="{schema}">
          <!--<protosite-controls :schema="schema" :data="c" @persist="persist"/>-->
        </template>
      </component>
    </template>
  </component>
</template>

<script>
  export default {
    name: 'Resolver',
    methods: {
      persist() {
        console.log('persisting....')
      },
    },
  }
</script>
