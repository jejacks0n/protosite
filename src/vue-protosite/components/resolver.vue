<template>
  <component ref="component" :is="resolve(protositePage, 'page')">
    <template slot="protosite" slot-scope="{schema}">
      <protosite-headful :title="protositePage.data.title" :description="protositePage.data.description || protositePage.data.title"/>
      <protosite-page-toolbar :schema="schema" @persist="persist"/>
    </template>
    <template slot="components">
      <component v-for="component in protositePage.data.components" :key="component.id" :is="resolve(component, 'component')" :data="component">
        <template slot="protosite" slot-scope="{schema}">
          <protosite-component-toolbar :schema="schema" :data="component" @persist="persist"/>
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
