<template>
  <v-footer height="44" app padless>
    <v-flex class="pl-4"> ThRadio (v{{ $config.version }}) </v-flex>

    <v-spacer></v-spacer>

    <v-layout class="pr-4" justify-end>
      <switch-locale></switch-locale>
    </v-layout>
  </v-footer>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'nuxt-property-decorator'

@Component
export default class FooterComponent extends Vue {
  @Prop(Boolean) readonly fixed: boolean | undefined

  go() {
    window.open('https://therhenals.com', 'blank')
  }
}
</script>
