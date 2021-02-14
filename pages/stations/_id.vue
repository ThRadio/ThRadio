<template>
  <div class="StationPage">
    <v-card>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-toolbar-title class="title white--text pl-0">
          {{ station.name }}
        </v-toolbar-title>

        <v-spacer></v-spacer>

        <v-menu auto bottom light min-width="150">
          <template #activator="{ on, attrs }">
            <v-btn dark icon v-bind="attrs" v-on="on">
              <v-icon>mdi-dots-vertical</v-icon>
            </v-btn>
          </template>

          <v-list>
            <v-list-item :to="`/stations/edit/${station._id}`">
              <v-list-item-title>Edit</v-list-item-title>
            </v-list-item>
            <v-list-item @click="remove(station._id)">
              <v-list-item-title>Remove</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-app-bar>
      <v-list two-line>
        <v-list-item v-if="station.description">
          <v-list-item-icon>
            <v-icon color="primary"> mdi-card-text </v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Description</v-list-item-title>
            <v-list-item-subtitle>{{
              station.description
            }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item v-if="station.genre">
          <v-list-item-icon>
            <v-icon color="primary"> mdi-format-list-bulleted-type </v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Genre</v-list-item-title>
            <v-list-item-subtitle>{{ station.genre }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-radio </v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Maximum listeners</v-list-item-title>
            <v-list-item-subtitle>{{ station.listeners }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-card>

    <v-card class="mt-3">
      <v-card-title primary-title> Icecast connection </v-card-title>
      <v-list two-line>
        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-link-box-variant </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>Host URL</v-list-item-title>
            <v-list-item-subtitle
              >{{ $store.getters.config.url_base }}:{{
                station.icecast_port
              }}</v-list-item-subtitle
            >
          </v-list-item-content>

          <v-list-item-icon
            @click="
              copy(`${$store.getters.config.url_base}:${station.icecast_port}`)
            "
          >
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-open-in-new </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>Administration URL</v-list-item-title>
            <v-list-item-subtitle
              >{{ $store.getters.config.url_base }}:{{
                station.icecast_port
              }}/admin.html</v-list-item-subtitle
            >
          </v-list-item-content>

          <v-list-item-icon
            @click="
              copy(
                `${$store.getters.config.url_base}:${station.icecast_port}/admin.html`
              )
            "
          >
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-lock-outline </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>Administrator password</v-list-item-title>
            <v-list-item-subtitle>{{
              station.icecast_password
            }}</v-list-item-subtitle>
          </v-list-item-content>

          <v-list-item-icon @click="copy(station.icecast_password)">
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-lock-outline </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>Source password</v-list-item-title>
            <v-list-item-subtitle>{{
              station.icecast_password
            }}</v-list-item-subtitle>
          </v-list-item-content>

          <v-list-item-icon @click="copy(station.icecast_password)">
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-airplane </v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Port</v-list-item-title>
            <v-list-item-subtitle>{{
              station.icecast_port
            }}</v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-icon @click="copy(station.icecast_port)">
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary"> mdi-radio-tower </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>Mount point</v-list-item-title>
            <v-list-item-subtitle>/radio.mp3</v-list-item-subtitle>
          </v-list-item-content>

          <v-list-item-icon @click="copy('/radio.mp3')">
            <v-icon>mdi-clipboard-text-multiple</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-list>
    </v-card>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>

    <v-snackbar v-model="snackbar.show" :timeout="3000">
      {{ snackbar.text }}

      <template #action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar.show = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'

@Component({
  head(this: StationPage): object {
    return {
      title: this.station.name,
    }
  },
})
export default class StationPage extends Vue {
  station: any
  loading = false
  $copyText: any
  snackbar = {
    show: false,
    text: '',
  }

  async asyncData({ $axios, params }: any) {
    const station = await $axios.$get(`/api/stations/${params.id}`)
    return { station }
  }

  async remove(id: string) {
    this.loading = true
    await this.$axios.$delete(`/api/stations/${id}`)
    this.$router.push('/')
  }

  async copy(text: string) {
    await this.$copyText(text)
    this.snackbar.show = true
    this.snackbar.text = 'Successfully copied'
  }
}
</script>
