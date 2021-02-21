<template>
  <v-app dark>
    <v-main>
      <v-container class="fill-height">
        <nuxt />
      </v-container>
    </v-main>
    <Footer></Footer>
  </v-app>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'

  @Component
  export default class BlankLayout extends Vue {}
</script>
