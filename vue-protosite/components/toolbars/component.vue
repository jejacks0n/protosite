<template>
  <section class="component-toolbar">
    [component toolbar]
    <button @click.prevent="onToggleEditing">edit</button>
    <form v-if="editing" novalidate @submit.prevent.stop="onSubmitted">
      <protosite-component-form v-model="data" :schema="schema" :ui-schema="uiFromSchema()" :options="options" @state-change="onStateChanged" @validated="onValidated"/>
      <button type="submit">Submit</button>
    </form>
  </section>
</template>

<script>
  // The component toolbar understands data about a component, manages the form
  // rendering for updating properties, and can call through to the persistence
  // logic provided to it.

  export default {
    name: 'ComponentToolbar',
    props: ['value', 'schema'],
    data() {
      return {
        data: this.value,
        editing: false,
        valid: false,
        submitted: false,
        success: false,
      }
    },
    computed: {
      options() {
        return {
          castToSchemaType: true,
          showValidationErrors: this.submitted,
        }
      },
    },
    watch: {
      data(data) {
        this.$emit('input', data)
      },
    },
    methods: {
      uiFromSchema() {
        // TODO: build out the default protosite form ui logic
        return this.schema.ui
      },

      onToggleEditing() {
        this.editing = !this.editing
      },
      onStateChanged(value) {
        console.log('onStateChanged', value)
      },
      onValidated(value) {
        this.valid = value
        console.log('onValidated', value)
      },
      onSubmitted() {
        this.submitted = true
        if (this.valid) {
          this.success = true
          this.$emit('persist', this.schema)
        }
      },
    },
  }
</script>
