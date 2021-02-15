<template>
  <div class="EditPage">
    <v-card>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-btn :to="`/stations/${station._id}`" icon>
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <v-toolbar-title class="title white--text pl-0">
          Edit station
        </v-toolbar-title>
      </v-app-bar>
      <v-card-text>
        <v-text-field
          v-model="name"
          dense
          label="Name"
          outlined
          block
          @input="$v.name.$touch()"
          @blur="$v.name.$touch()"
        ></v-text-field>

        <v-textarea
          v-model="description"
          outlined
          dense
          label="Description"
          hint="Optional"
          @input="$v.description.$touch()"
          @blur="$v.description.$touch()"
        ></v-textarea>

        <v-text-field
          v-model="genre"
          outlined
          dense
          block
          label="Genre"
          hint="Optional"
          @input="$v.genre.$touch()"
          @blur="$v.genre.$touch()"
        ></v-text-field>

        <v-text-field
          v-model="icecastPassword"
          dense
          label="Password icecast"
          outlined
          block
          @input="$v.icecastPassword.$touch()"
          @blur="$v.icecastPassword.$touch()"
        ></v-text-field>

        <v-text-field
          v-model="icecastPort"
          dense
          label="Port icecast"
          outlined
          block
          @input="$v.icecastPort.$touch()"
          @blur="$v.icecastPort.$touch()"
        ></v-text-field>

        <v-text-field
          v-model="listeners"
          outlined
          dense
          block
          label="Maximum listeners"
          hint="Optional (Default 250)"
          @input="$v.listeners.$touch()"
          @blur="$v.listeners.$touch()"
        ></v-text-field>

        <v-btn
          :disabled="$v.$invalid"
          depressed
          block
          color="primary"
          @click="edit()"
        >
          <v-icon left>mdi-pencil</v-icon>
          Edit station
        </v-btn>
      </v-card-text>
    </v-card>

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
    head(this: EditPage): object {
      return {
        title: `Edit ${this.station.name}`,
      }
    },
  })
  export default class EditPage extends Vue {
    station: any
    name: string = ''
    description: string = ''
    genre: string = ''
    listeners: string = ''
    icecastPassword: string = ''
    icecastPort: string = ''
    loading = false

    @Validations()
    validations = {
      name: { required },
      description: {},
      genre: {},
      listeners: { numeric },
      icecastPassword: { required },
      icecastPort: { required, numeric },
    }

    async asyncData({ $axios, params }: any) {
      const station = await $axios.$get(`/api/stations/${params.id}`)
      return { station }
    }

    mounted() {
      this.name = this.station.name
      this.description = this.station.description
      this.genre = this.station.genre
      this.listeners = this.station.listeners
      this.icecastPassword = this.station.icecast_password
      this.icecastPort = this.station.icecast_port
    }

    async edit() {
      this.loading = true
      await this.$axios.$put(`/api/stations/${this.$route.params.id}`, {
        name: this.name,
        description: this.description,
        genre: this.genre,
        icecast_password: this.icecastPassword,
        icecast_port: Number(this.icecastPort),
        listeners: this.listeners !== '0' ? Number(this.listeners) : 250,
      })
      this.$router.push(`/stations/${this.$route.params.id}`)
    }
  }
</script>
