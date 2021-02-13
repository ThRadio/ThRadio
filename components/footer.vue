<template>
  <v-footer padless app>
    <v-col class="text-center" cols="12" @click="go">
      {{ new Date().getFullYear() }} —
      <strong>Developed by TheRhenals</strong>
    </v-col>
  </v-footer>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'

@Component
export default class FooterComponent extends Vue {
  go() {
    window.open('https://therhenals.com', 'blank')
  }
}
</script>
