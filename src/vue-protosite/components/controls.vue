<template>
  <article class="protosite-controls">
    <div class="interface">
      <div class="title">{{resolveComponent(data).name}}:</div>
      <div class="actions">
        <button class="btn configure" @click.stop="openComponentForm()" :class="{active: showComponentForm}">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M22.2 14.4l-1.2-.7c-1.3-.8-1.3-2.7 0-3.5l1.2-.7c1-.6 1.3-1.8.7-2.7l-1-1.7c-.6-1-1.8-1.3-2.7-.7l-1.2.7c-1.3.8-3-.2-3-1.7V2c0-1.1-.9-2-2-2h-2C9.9 0 9 .9 9 2v1.3C9 4.8 7.3 5.8 6 5l-1.2-.6c-1-.6-2.2-.2-2.7.7l-1 1.7c-.5 1-.2 2.2.7 2.8l1.2.7c1.3.7 1.3 2.7 0 3.4l-1.2.7c-1 .6-1.3 1.8-.7 2.7l1 1.7c.6 1 1.8 1.3 2.7.7l1.2-.6c1.3-.8 3 .2 3 1.7V22c0 1.1.9 2 2 2h2c1.1 0 2-.9 2-2v-1.3c0-1.5 1.7-2.5 3-1.7l1.2.7c1 .6 2.2.2 2.7-.7l1-1.7c.5-1.1.2-2.3-.7-2.9zM12 16c-2.2 0-4-1.8-4-4s1.8-4 4-4 4 1.8 4 4-1.8 4-4 4z"/>
          </svg>
        </button>
        <button class="btn add" @click.stop="addComponent()">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 1C5.9 1 1 5.9 1 12s4.9 11 11 11 11-4.9 11-11S18.1 1 12 1zm5 13h-3v3c0 1.1-.9 2-2 2s-2-.9-2-2v-3H7c-1.1 0-2-.9-2-2s.9-2 2-2h3V7c0-1.1.9-2 2-2s2 .9 2 2v3h3c1.1 0 2 .9 2 2s-.9 2-2 2z"/>
          </svg>
        </button>
        <button class="btn remove" @click.stop="removeComponent()">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M14.8 12l3.6-3.6c.8-.8.8-2 0-2.8-.8-.8-2-.8-2.8 0L12 9.2 8.4 5.6c-.8-.8-2-.8-2.8 0-.8.8-.8 2 0 2.8L9.2 12l-3.6 3.6c-.8.8-.8 2 0 2.8.4.4.9.6 1.4.6s1-.2 1.4-.6l3.6-3.6 3.6 3.6c.4.4.9.6 1.4.6s1-.2 1.4-.6c.8-.8.8-2 0-2.8L14.8 12z"/>
          </svg>
        </button>
      </div>
      <div v-if="$protosite.debug" class="debug">
        <button class="debug btn btn-primary btn-small tip tip-right" :aria-label="debugInfo">Debug</button>
      </div>
    </div>
    <protosite-modal :visible="showComponentForm" @close="showComponentForm = false">
      <FormSchema :schema="schema" v-model="mutableData" @submit.prevent="saveComponentForm">
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </FormSchema>
    </protosite-modal>
  </article>
</template>

<script>
  import FormSchema from '@formschema/native'

  export default {
    name: 'Controls',
    props: ['schema', 'data'],
    components: { FormSchema },
    data() {
      return {
        mutableData: this.data,
        showComponentForm: false,
      }
    },
    computed: {
      debugInfo() {
        return [
          `Type: ${this.data.type}`,
          `Component: ${this.resolveComponent(this.data).name}`,
        ].join('\n')
      },
    },
    methods: {
      openComponentForm() {
        this.showComponentForm = true
        // setTimeout(() => this.$protosite.persistPage(this.page), 10)
      },

      saveComponentForm() {
        this.showComponentForm = false
        this.$emit('persist', this.page, this.data, this.mutableData)
      },

      addComponent() {
        this.page.components.push(this.defaultsFromSchema(this.schema, {type: 'hero'}))
        this.persistPage();
      },

      removeComponent() {
        this.$emit('persist', this.page, this.data, null)
      }
    },
  }
</script>

<style scoped lang="scss">
  @import '../styles/tip';
  @import '../styles/btn';

  article.protosite-controls {
    position: absolute;
    z-index: 10000;
    margin-top: -20px;
    background: #e3e6ef;
    border-radius: 8px;
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.16);
    text-align: center;
    user-select: none;
    background-clip: padding-box;
  }

  div.title {
    display: inline-block;
    max-width: 80px;
    padding: 0 5px 0 20px;
    line-height: 40px;
    vertical-align: top;
    text-shadow: 0 -1px 0 #fff;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  div.actions {
    display: inline-block;
    vertical-align: top;
    border-left: 1px solid #d1d6e0;
    button {
      width: 40px;
      height: 40px;
      padding: 0;
      border-radius: 0;
      svg {
        width: 20px;
        height: 20px;
        path {
          fill: #9ba4ad;
        }
      }
      &.active {
        background-color: #ea4569 !important;
        &.configure {
          background-color: #29bb9c !important;
        }
        svg {
          filter: drop-shadow(0.5px 1px 1px rgba(#000, 0.2));
          path {
            fill: #fff;
          }
        }
      }
    }
  }

  div.debug {
    display: inline-block;
    vertical-align: top;
    padding: 10px 10px;
    button.debug {
      border: 0;
      padding: 4px 5px 3px;
      margin: auto;
      font-size: 11px;
    }
  }
</style>
