<template>
  <article class="protosite-toolbar" :class="{closed}">
    <div class="drag-handle" @dblclick.stop.prevent="closed = !closed">&bull; &bull; &bull;</div>
    <div class="interface">
      <div class="actions">
        <button class="configure btn" @click.stop="openPageForm()" :class="{active: showPageForm}">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M22.2 14.4l-1.2-.7c-1.3-.8-1.3-2.7 0-3.5l1.2-.7c1-.6 1.3-1.8.7-2.7l-1-1.7c-.6-1-1.8-1.3-2.7-.7l-1.2.7c-1.3.8-3-.2-3-1.7V2c0-1.1-.9-2-2-2h-2C9.9 0 9 .9 9 2v1.3C9 4.8 7.3 5.8 6 5l-1.2-.6c-1-.6-2.2-.2-2.7.7l-1 1.7c-.5 1-.2 2.2.7 2.8l1.2.7c1.3.7 1.3 2.7 0 3.4l-1.2.7c-1 .6-1.3 1.8-.7 2.7l1 1.7c.6 1 1.8 1.3 2.7.7l1.2-.6c1.3-.8 3 .2 3 1.7V22c0 1.1.9 2 2 2h2c1.1 0 2-.9 2-2v-1.3c0-1.5 1.7-2.5 3-1.7l1.2.7c1 .6 2.2.2 2.7-.7l1-1.7c.5-1.1.2-2.3-.7-2.9zM12 16c-2.2 0-4-1.8-4-4s1.8-4 4-4 4 1.8 4 4-1.8 4-4 4z"/>
          </svg>
        </button>
        <button class="edit btn" @click.stop="togglePageEdit()" :class="{active: page.editing}">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M2 20c0 1.1.9 2 2 2h2.6L2 17.4V20zM21.6 5.6l-3.2-3.2c-.8-.8-2-.8-2.8 0l-.2.2c-.4.4-.4 1 0 1.4L20 8.6c.4.4 1 .4 1.4 0l.2-.2c.8-.8.8-2 0-2.8zM14 5.4c-.4-.4-1-.4-1.4 0l-9.1 9.1C3 15 3 15.6 3.4 16L8 20.6c.4.4 1 .4 1.4 0l9.1-9.1c.4-.4.4-1 0-1.4L14 5.4z"/>
          </svg>
        </button>
      </div>
      <div class="users">
        <div class="avatar tip tip-left" aria-label="jejacks0n"></div>
      </div>
      <div v-if="$protosite.debug" class="debug">
        <button class="debug btn btn-primary btn-small tip tip-left" :aria-label="debugInfo">Debug</button>
      </div>
    </div>
    <protosite-modal :visible="showPageForm" @close="showPageForm = false">
      <FormSchema :schema="schema" v-model="page" @submit.prevent="savePageForm">
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </FormSchema>
    </protosite-modal>
  </article>
</template>

<script>
  import FormSchema from '@formschema/native'

  export default {
    name: 'Toolbar',
    props: ['schema'],
    components: { FormSchema },
    data() {
      return {
        closed: false,
        showPageForm: false,
        editingPage: false,
      }
    },
    computed: {
      debugInfo() {
        return [
          `Template: ${this.resolveTemplate(this.page).name}`,
          `Title: ${this.page.title}`,
          `Path: ${this.page.fullPath}`,
        ].join('\n')
      },
    },
    methods: {
      togglePageEdit() {
        if (typeof this.page.editing === 'undefined') this.page.editing = false
        this.page.editing = !this.page.editing
        setTimeout(() => this.$protosite.persistPage(this.page), 10)
      },

      openPageForm() {
        this.showPageForm = true
        setTimeout(() => this.$protosite.persistPage(this.page), 10)
      },

      savePageForm() {
        this.showPageForm = false
        this.$emit('persist', this.page)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '../styles/tip';
  @import '../styles/btn';

  article.protosite-toolbar {
    position: fixed;
    z-index: 10001;
    bottom: 10px;
    right: 10px;
    width: 80px;
    background: #e3e6ef;
    border-radius: 8px;
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.16);
    text-align: center;
    user-select: none;
    background-clip: padding-box;
    &.closed {
      div.interface {
        display: none;
      }
    }
  }

  div.drag-handle {
    font-size: 30px;
    letter-spacing: -2px;
    color: #bac1cc;
    cursor: pointer;
  }

  div.actions {
    border-top: 1px solid #d1d6e0;
    button {
      width: 100%;
      height: 70px;
      padding: 0;
      border-radius: 0;
      svg {
        width: 50px;
        height: 50px;
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

  div.users {
    padding: 20px 10px;
    background: #f0f2f7;
    div.avatar {
      width: 58px;
      height: 58px;
      margin: auto;
      background: url('../images/photo.jpg') no-repeat center;
      background-size: cover;
      border-radius: 50%;
    }
  }

  div.debug {
    padding: 10px 10px;
    button.debug {
      border: 0;
      display: block;
      width: 100%;
      padding: 4px 0 3px;
      margin: auto;
      font-size: 11px;
    }
  }
</style>
