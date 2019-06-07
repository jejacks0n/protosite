<template>
  <section class="page-toolbar">
    [page toolbar]
    <button @click.prevent="onToggleEditing">edit</button>
    <form v-if="editing" novalidate @submit.prevent.stop="onSubmitted">
      <protosite-page-form v-model="data" :schema="schema" :ui-schema="uiFromSchema()" :options="options" @state-change="onStateChanged" @validated="onValidated"/>
      <button type="submit">Submit</button>
    </form>
  </section>
</template>

<script>
  // The page toolbar understands things about page and manages rendering the
  // form for the page schema, page persistence, display version history,
  // provide version management and logic for user assignment.

  export default {
    name: 'PageToolbar',
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
