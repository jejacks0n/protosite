<template>
  <transition name="modal">
    <article class="modal" v-if="visible">
      <div class="container">
        <a @click.prevent="close" class="close btn btn-black btn-outline btn-circle">&times;</a>
        <slot/>
      </div>
    </article>
  </transition>
</template>

<script>
  export default {
    name: 'Modal',
    props: ['visible'],
    methods: {
      disableScrolling() {
        this.originalTop = Math.max(document.body.scrollTop, document.documentElement.scrollTop)
        this.originalLeft = Math.max(document.body.scrollLeft, document.documentElement.scrollLeft)
        document.body.style.setProperty('--top', -this.originalTop + 'px')
        document.body.style.setProperty('--left', -this.originalLeft + 'px')
        document.body.classList.add('no-scroll')
      },

      enableScrolling() {
        document.body.classList.remove('no-scroll')
        document.body.scrollTop = this.originalTop;
        document.documentElement.scrollTop = this.originalTop;
        document.body.scrollLeft = this.originalLeft;
        document.documentElement.scrollLeft = this.originalLeft;
      },

      close() {
        this.enableScrolling()
        this.$emit('close')
      },
    },
    watch: {
      visible: function(val) {
        if (val) {
          this.disableScrolling()
        } else {
          this.enableScrolling()
        }
      },
    },
  }
</script>

<style lang="scss">
  body.no-scroll {
    overflow: hidden;
    position: fixed;
    width: 100%;
    height: 100%;
    top: var(--top);
    left: var(--left);
  }
</style>

<style scoped lang="scss">
  @import '../styles/variables';
  @import '../styles/btn';

  article.modal {
    position: fixed;
    z-index: 10000;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    overflow: scroll;
    overflow-scrolling: touch;
    &.modal-enter-active {
      animation: slide-up $speed / 2 $ease-ios-panel both;
    }
    &.modal-leave-active {
      animation: slide-down $speed / 2 $ease-ios-panel both;
    }
  }

  div.container {
    position: relative;
    margin: auto;
    width: 100%;
    min-height: 100vh;
    box-sizing: border-box;
    padding: 40px;
    background: #f0f2f7;
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
  }

  a.close {
    display: block;
    position: absolute;
    top: 10px;
    right: 10px;
  }

  @media (min-width: 719px) {
    article.modal {
      display: grid;
      background: rgba(#000, 0.4);
      &.modal-enter-active {
        animation: fade-in $speed / 3 $ease-in-out-aggro both;
        div.container {
          animation: drop-in $speed / 2 $ease-in-out-aggro both;
        }
      }
      &.modal-leave-active {
        animation: fade-out $speed / 3 $ease-in-out-aggro both;
      }
    }

    div.container {
      max-width: 680px;
      min-height: 0;
      padding: 40px 90px;
      overflow: visible;
      border-radius: 10px;

    }

    a.close {
      top: 30px;
      right: 30px;
    }
  }

  @keyframes slide-up {
    from {
      transform: translateY(100vh);
    }
    to {
      transform: translateY(0);
    }
  }

  @keyframes slide-down {
    from {
      transform: translateY(0);
    }
    to {
      transform: translateY(100vh);
    }
  }

  @keyframes fade-in {
    from {
      background: rgba(#000, 0);
    }
    to {
      background: rgba(#000, 0.4);
    }
  }

  @keyframes fade-out {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }

  @keyframes drop-in {
    from {
      opacity: 0;
      transform: scale(1.15);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
</style>
