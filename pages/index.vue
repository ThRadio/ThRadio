<template>
  <div class="HomePage">
    <v-row
      v-if="
        semver.gt(semver.coerce(info.version), semver.coerce($config.version))
      "
      class="mb-2"
      align="center"
    >
      <v-col cols="12" md="9" class="grow">
        <v-alert
          class="mb-0"
          prominent
          dense
          type="info"
          icon="mdi-rocket-launch"
        >
          {{ $t('msg_update') }}
        </v-alert>
      </v-col>
      <v-col cols="12" md="3" class="shrink">
        <v-btn
          href="https://bit.ly/thradio-update"
          target="blank"
          color="primary"
          block
        >
          <v-icon left>mdi-rocket-launch</v-icon>
          {{ $t('update') }}
        </v-btn>
      </v-col>
    </v-row>

    <v-card>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-toolbar-title class="title white--text pl-0">
          {{ $t('stations') }}
        </v-toolbar-title>

        <v-spacer></v-spacer>

        <v-btn :to="localePath('/stations/add')" icon>
          <v-icon>mdi-plus-circle</v-icon>
        </v-btn>
      </v-app-bar>
      <v-simple-table dark>
        <template #default>
          <thead>
            <tr>
              <th class="text-left">{{ $t('name') }}</th>
              <th class="text-left">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="!stations.length">
              <td>{{ $t('not_found') }}</td>
              <td>
                <v-btn :to="localePath('/stations/add')" dark plain>
                  <v-icon left>mdi-plus-circle</v-icon>
                  {{ $t('add_station') }}
                </v-btn>
              </td>
            </tr>
            <tr
              v-for="station in stations"
              :key="station._id"
              @click="go(station._id)"
            >
              <td>{{ station.name }}</td>
              <td>
                <v-menu auto bottom light min-width="150">
                  <template #activator="{ on, attrs }">
                    <v-btn dark icon v-bind="attrs" v-on="on">
                      <v-icon>mdi-dots-vertical</v-icon>
                    </v-btn>
                  </template>

                  <v-list>
                    <v-list-item
                      :to="localePath(`/stations/edit/${station._id}`)"
                    >
                      <v-list-item-icon>
                        <v-icon dense> mdi-pencil </v-icon>
                      </v-list-item-icon>
                      <v-list-item-title>{{ $t('edit') }}</v-list-item-title>
                    </v-list-item>
                    <v-list-item @click="remove(station._id)">
                      <v-list-item-icon>
                        <v-icon dense> mdi-delete </v-icon>
                      </v-list-item-icon>
                      <v-list-item-title>{{ $t('remove') }}</v-list-item-title>
                    </v-list-item>
                  </v-list>
                </v-menu>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-card>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </div>
</template>

<script lang="ts">
  import * as semver from 'semver'
  import { Component, Vue } from 'nuxt-property-decorator'

  @Component({
    head(this: HomePage): object {
      return {
        title: this.$t('home'),
      }
    },
  })
  export default class HomePage extends Vue {
    semver = semver
    loading = false
    async asyncData({ $axios }: any) {
      const stations = await $axios.$get('/api/stations')
      const info = await $axios.$get('/api/app/info')
      return { stations, info }
    }

    async remove(id: string) {
      this.loading = true
      await this.$axios.$delete(`/api/stations/${id}`)
      await this.$nuxt.refresh()
      this.loading = false
    }

    go(id: string) {
      this.$router.push(this.localePath('/stations/' + id))
    }
  }
</script>
