<template>
  <div class="AddStationPage">
    <Stepper :value="step" :steps="2">
      <!-- Title -->
      <template #title>
        <v-card-title primary-title> Add station </v-card-title>
      </template>

      <!-- Titles steps -->
      <template #step-1>
        <v-stepper-step :complete="step > 1" step="1">
          Information
        </v-stepper-step>
      </template>

      <template #step-2>
        <v-stepper-step :complete="step > 2" step="2"> Icecast </v-stepper-step>
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

            <v-card-actions class="pa-0 pt-2">
              <v-btn
                color="primary"
                :disabled="$v.information.$invalid"
                @click="step = 2"
              >
                <v-icon left>mdi-arrow-right</v-icon>
                Continue
              </v-btn>
            </v-card-actions>
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

            <v-card-actions class="pa-0 pt-2">
              <v-btn outlined color="primary" @click="step = 1">
                <v-icon left>mdi-arrow-left</v-icon>
                Back
              </v-btn>

              <v-btn color="primary" :disabled="$v.$invalid" @click="add">
                <v-icon left>mdi-plus-circle</v-icon>
                Add station
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>
      </template>
    </Stepper>

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
    head: {
      title: 'Add station',
    },
  })
  export default class AddStationPage extends Vue {
    step = 1
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

    async add() {
      this.loading = true
      const station = await this.$axios.$post('/api/stations', {
        name: this.information.name,
        description: this.information.description,
        genre: this.information.genre,
        icecast_password: this.icecast.password,
        icecast_port: Number(this.icecast.port),
        listeners:
          this.icecast.listeners !== '' ? Number(this.icecast.listeners) : 250,
      })
      this.$router.push(`/stations/${station._id}`)
    }
  }
</script>
