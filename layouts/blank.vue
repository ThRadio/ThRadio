<template>
  <v-app dark>
    <v-main>
      <v-container fill-height>
        <nuxt />
      </v-container>
    </v-main>
    <FooterComponent></FooterComponent>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
import FooterComponent from '~/components/footer.vue'
@Component({
  components: { FooterComponent },
})
export default class BlankLayout extends Vue {}
</script>
