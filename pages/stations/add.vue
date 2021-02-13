<template>
  <div class="AddStationPage">
    <v-card>
      <v-card-title primary-title> Add station </v-card-title>
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
          @input="$v.genre.$touch()"
          @blur="$v.genre.$touch()"
        ></v-text-field>

        <v-btn
          :disabled="$v.$invalid"
          depressed
          block
          color="primary"
          @click="add()"
        >
          <v-icon left>mdi-plus-circle</v-icon>
          Add station
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
      title: 'Add station',
    }
  },
})
export default class EditPage extends Vue {
  name: string = ''
  description: string = ''
  genre: string = ''
  icecastPassword: string = ''
  icecastPort: string = ''
  listeners: string = ''
  loading = false

  @Validations()
  validations = {
    name: { required },
    description: {},
    genre: {},
    icecastPassword: { required },
    icecastPort: { required, numeric },
    listeners: { numeric },
  }

  async add() {
    this.loading = true
    const station = await this.$axios.$post('/api/stations', {
      name: this.name,
      description: this.description,
      genre: this.genre,
      icecast_password: this.icecastPassword,
      icecast_port: Number(this.icecastPort),
      listeners: this.listeners !== '' ? Number(this.listeners) : 250,
    })
    this.$router.push(`/stations/${station._id}`)
  }
}
</script>
