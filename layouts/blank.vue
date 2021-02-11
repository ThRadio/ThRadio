<template>
  <v-app dark>
    <v-main>
      <v-container fill-height>
        <nuxt />
      </v-container>
    </v-main>
    <v-footer padless app>
      <v-col class="text-center" cols="12">
        {{ new Date().getFullYear() }} —
        <strong>Developed by TheRhenals</strong>
      </v-col>
    </v-footer>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'

@Component
export default class BlankLayout extends Vue {}
</script>
