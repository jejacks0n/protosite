<template>
  <section class="global-toolbar">
    [global toolbar]
    <a href="#" @click.prevent="logout">sign out</a>
  </section>
</template>

<script>
  // The global toolbar understands general authentication aspects, the current
  // user, manages graphql subscriptions and site wide configuration and custom
  // object management (like product management for instance).

  export default {
    name: 'GlobalToolbar',
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
