<template>
  <div class="HomePage">
    <v-card>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-toolbar-title class="title white--text pl-0">
          Stations
        </v-toolbar-title>

        <v-spacer></v-spacer>

        <v-btn to="/stations/add" icon>
          <v-icon>mdi-plus-circle</v-icon>
        </v-btn>
      </v-app-bar>
      <v-simple-table dark>
        <template #default>
          <thead>
            <tr>
              <th class="text-left">Name</th>
              <th class="text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="!stations.length">
              <td>Not found</td>
              <td>
                <v-btn to="/stations/add" dark plain>
                  <v-icon left>mdi-plus-circle</v-icon>
                  Add new station
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
                    <v-list-item :to="`/stations/edit/${station._id}`">
                      <v-list-item-icon>
                        <v-icon dense> mdi-pencil </v-icon>
                      </v-list-item-icon>
                      <v-list-item-title>Edit</v-list-item-title>
                    </v-list-item>
                    <v-list-item @click="remove(station._id)">
                      <v-list-item-icon>
                        <v-icon dense> mdi-delete </v-icon>
                      </v-list-item-icon>
                      <v-list-item-title>Remove</v-list-item-title>
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
  import { Component, Vue } from 'nuxt-property-decorator'

  @Component({
    head: {
      title: 'Home',
    },
  })
  export default class HomePage extends Vue {
    loading = false
    async asyncData({ $axios }: any) {
      const stations = await $axios.$get('/api/stations')
      return { stations }
    }

    async remove(id: string) {
      this.loading = true
      await this.$axios.$delete(`/api/stations/${id}`)
      await this.$nuxt.refresh()
      this.loading = false
    }

    go(id: string) {
      this.$router.push('./stations/' + id)
    }
  }
</script>
