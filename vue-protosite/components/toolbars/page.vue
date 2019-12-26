<template>
  <section class="page-toolbar">
    [page toolbar]
    <button @click.prevent="onToggleEditing">edit</button>
    <form v-if="editing" novalidate @submit.prevent.stop="onSubmitted">
      <protosite-form v-model="model" :schema="schemas.object" :ui-schema="schemas.ui" :options="options" @validated="onValidated"/>
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
        model: this.$protosite.defaultValues(this.value, this.schema),
        editing: false,
        valid: false,
        submitted: false,
        success: false,
      }
    },
    computed: {
      schemas() {
        return this.$protosite.schemas(this.schema)
      },
      options() {
        return {
          castToSchemaType: true,
          showValidationErrors: this.submitted,
        }
      },
    },
    watch: {
      model(value) {
        this.$emit('input', value)
      },
    },
    methods: {
      onToggleEditing() {
        this.editing = !this.editing
      },
      onValidated(value) {
        this.valid = value
        console.log('valid', value)
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
