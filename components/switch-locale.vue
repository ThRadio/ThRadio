<template>
  <v-menu top offset-y>
    <template #activator="{ on, attrs }">
      <v-btn class="my-2" v-bind="attrs" small outlined rounded v-on="on">
        <v-icon left>mdi-translate</v-icon>
        {{ $t('language') }}
      </v-btn>
    </template>
    <v-list dense>
      <v-list-item
        v-for="(locale, index) in availableLocales"
        :key="index"
        @click="setLocale(locale.code)"
      >
        <v-list-item-title>{{ locale.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
@Component
export default class SwitchComponent extends Vue {
  get availableLocales() {
    return this.$i18n.locales
  }

  async setLocale(locale: string) {
    await this.$i18n.setLocale(locale)
  }
}
</script>
