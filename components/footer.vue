<template>
  <v-footer class="grey darken-3" padless app>
    <v-row justify="center" no-gutters>
      <v-menu top offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn class="my-2" v-bind="attrs" v-on="on" small outlined rounded>
            <v-icon left>mdi-translate</v-icon>
            {{ $t('language') }}
          </v-btn>
        </template>
        <v-list dense>
          <v-list-item
            @click="setLocale(locale.code)"
            v-for="(locale, index) in availableLocales"
            :key="index"
          >
            <v-list-item-title>{{ locale.name }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>

      <v-col class="grey darken-4 py-2 text-center white--text" cols="12">
        ThRadio (v{{ $config.version }}) —
        <strong>Developed by TheRhenals</strong>
      </v-col>
    </v-row>
  </v-footer>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'

  @Component
  export default class FooterComponent extends Vue {
    links = ['Home', 'About Us', 'Team', 'Services', 'Blog', 'Contact Us']
    go() {
      window.open('https://therhenals.com', 'blank')
    }

    get availableLocales() {
      return this.$i18n.locales
    }

    async setLocale(locale: string) {
      await this.$i18n.setLocale(locale)
    }
  }
</script>
