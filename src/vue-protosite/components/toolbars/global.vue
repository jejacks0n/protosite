<template>
  <section class="global-toolbar">
    [global toolbar]
    <a href="#" @click.prevent="logout">sign out</a>
  </section>
</template>

<script>
  // The global toolbar understands things about authentication, the user, and
  // will eventually manage graphql subscriptions (when that makes sense).

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
