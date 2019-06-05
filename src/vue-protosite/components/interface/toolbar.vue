<template>
  <section class="toolbar">
    [toolbar]
    <a href="#" @click.prevent="logout">sign out</a>
  </section>
</template>

<script>
  export default {
    name: 'Toolbar',
    methods: {
      logout() {
        let oReq = new XMLHttpRequest()
        oReq.addEventListener("load", () => location.reload())
        oReq.open('DELETE', '/protosite', true)
        oReq.send()
      },
    },
  }
</script>
