<template>
  <div class="EditStationPage">
    <Stepper :step="step" :steps="2">
      <!-- Title -->
      <template #title>
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-btn :to="`/stations/${station._id}`" icon>
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <v-toolbar-title class="title white--text pl-0">
            Edit station
          </v-toolbar-title>
        </v-app-bar>
      </template>

      <!-- Titles steps -->
      <template #step-1>
        <v-stepper-step
          :rules="[() => !$v.information.$invalid]"
          editable
          :complete="!$v.information.$invalid"
          step="1"
        >
          Information
          <small v-if="$v.information.$invalid">Incomplete</small>
        </v-stepper-step>
      </template>

      <template #step-2>
        <v-stepper-step
          :rules="[() => !$v.icecast.$invalid]"
          editable
          :complete="!$v.icecast.$invalid"
          step="2"
        >
          Icecast
          <small v-if="$v.icecast.$invalid">Incomplete</small>
        </v-stepper-step>
      </template>

      <!-- Content steps -->
      <template #content-1>
        <v-stepper-content step="1">
          <v-card flat color="transparent" class="mb-4">
            <v-card-text class="pa-0 pt-2">
              <v-text-field
                v-model="information.name"
                dense
                label="Name"
                outlined
                block
                @input="$v.information.name.$touch()"
                @blur="$v.information.name.$touch()"
              ></v-text-field>

              <v-textarea
                v-model="information.description"
                outlined
                dense
                label="Description"
                hint="Optional"
                @input="$v.information.description.$touch()"
                @blur="$v.information.description.$touch()"
              ></v-textarea>

              <v-text-field
                v-model="information.genre"
                outlined
                dense
                block
                label="Genre"
                hint="Optional"
                @input="$v.information.genre.$touch()"
                @blur="$v.information.genre.$touch()"
              ></v-text-field>
            </v-card-text>
          </v-card>
        </v-stepper-content>
      </template>

      <template #content-2>
        <v-stepper-content step="2">
          <v-card flat color="transparent" class="mb-4">
            <v-card-text class="pa-0 pt-2">
              <v-text-field
                v-model="icecast.password"
                dense
                label="Password icecast"
                outlined
                block
                @input="$v.icecast.password.$touch()"
                @blur="$v.icecast.password.$touch()"
              ></v-text-field>

              <v-text-field
                v-model="icecast.port"
                dense
                label="Port icecast"
                outlined
                block
                @input="$v.icecast.port.$touch()"
                @blur="$v.icecast.port.$touch()"
              ></v-text-field>

              <v-text-field
                v-model="icecast.listeners"
                outlined
                dense
                block
                label="Maximum listeners"
                hint="Optional (Default 250)"
                @input="$v.icecast.listeners.$touch()"
                @blur="$v.icecast.listeners.$touch()"
              ></v-text-field>
            </v-card-text>
          </v-card>
        </v-stepper-content>
      </template>
    </Stepper>

    <v-btn
      class="mt-3"
      block
      color="primary"
      :disabled="$v.$invalid"
      @click="edit"
    >
      <v-icon left>mdi-pencil</v-icon>
      Edit station
    </v-btn>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </div>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'
  import { Validations } from 'vuelidate-property-decorators'
  import { required, numeric } from 'vuelidate/lib/validators'

  @Component({
    head(this: EditStationPage): object {
      return {
        title: `Edit ${this.station.name}`,
      }
    },
  })
  export default class EditStationPage extends Vue {
    step = 1
    station: any
    information = {
      name: '',
      description: '',
      genre: '',
    }
    icecast = {
      password: '',
      port: '',
      listeners: '',
    }
    loading = false

    @Validations()
    validations = {
      information: {
        name: { required },
        description: {},
        genre: {},
      },
      icecast: {
        password: { required },
        port: { required, numeric },
        listeners: { numeric },
      },
    }

    async asyncData({ $axios, params }: any) {
      const station = await $axios.$get(`/api/stations/${params.id}`)
      return { station }
    }

    mounted() {
      this.information = {
        name: this.station.name,
        description: this.station.description,
        genre: this.station.genre,
      }
      this.icecast = {
        listeners: this.station.listeners,
        password: this.station.icecast_password,
        port: this.station.icecast_port,
      }
    }

    async edit() {
      this.loading = true
      await this.$axios.$put(`/api/stations/${this.$route.params.id}`, {
        name: this.information.name,
        description: this.information.description,
        genre: this.information.genre,
        icecast_password: this.icecast.password,
        icecast_port: Number(this.icecast.port),
        listeners:
          this.icecast.listeners !== '' ? Number(this.icecast.listeners) : 250,
      })
      this.$router.push(`/stations/${this.$route.params.id}`)
    }
  }
</script>
