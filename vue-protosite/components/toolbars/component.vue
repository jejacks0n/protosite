<template>
  <section class="component-toolbar">
    [component toolbar]
    <button @click.prevent="onToggleEditing">edit</button>
    <form v-if="editing" novalidate @submit.prevent.stop="onSubmitted">
      <protosite-form v-model="model" :schema="schemas.object" :ui-schema="schemas.ui" :options="options" @validated="onValidated"/>
      <button type="submit">Submit</button>
    </form>
  </section>
</template>

<script>
  // The component toolbar understands data about a component, manages the form
  // rendering for updating properties, and can call through to the persistence
  // logic provided to it.
  import PageToolbar from './page.vue'

  export default {
    name: 'ComponentToolbar',
    extends: PageToolbar,
  }
</script>
