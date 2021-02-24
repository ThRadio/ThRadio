<template>
  <div class="AddStationPage">
    <Stepper :value="step" :steps="3">
      <!-- Title -->
      <template #title>
        <v-card-title primary-title> {{ $t('add_station') }} </v-card-title>
      </template>

      <!-- Titles steps -->
      <template #step-1>
        <v-stepper-step :complete="step > 1" step="1">
          {{ $t('information') }}
        </v-stepper-step>
      </template>

      <template #step-2>
        <v-stepper-step :complete="step > 2" step="2"> Icecast </v-stepper-step>
      </template>

      <template #step-3>
        <v-stepper-step :complete="step > 3" step="3">
          {{ $t('user') }}
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
                :label="$t('name')"
                outlined
                block
                @input="$v.information.name.$touch()"
                @blur="$v.information.name.$touch()"
                @keyup="user.name = `${information.name} user`"
              ></v-text-field>

              <v-textarea
                v-model="information.description"
                outlined
                dense
                :label="$t('description')"
                :messages="$t('optional')"
                @input="$v.information.description.$touch()"
                @blur="$v.information.description.$touch()"
              ></v-textarea>

              <v-text-field
                v-model="information.genre"
                outlined
                dense
                block
                :label="$t('genre')"
                :messages="$t('optional')"
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
                {{ $t('continue') }}
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
                :label="$t('password')"
                outlined
                block
                @input="$v.icecast.password.$touch()"
                @blur="$v.icecast.password.$touch()"
              ></v-text-field>

              <v-text-field
                v-model="icecast.port"
                dense
                :label="$t('port')"
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
                :label="$t('maximum_listeners')"
                :messages="`${$t('optional')} (${$t('default')} 250)`"
                @input="$v.icecast.listeners.$touch()"
                @blur="$v.icecast.listeners.$touch()"
              ></v-text-field>
            </v-card-text>

            <v-card-actions class="pa-0 pt-2">
              <v-btn outlined color="primary" @click="step = 1">
                <v-icon left>mdi-arrow-left</v-icon>
                {{ $t('back') }}
              </v-btn>

              <v-btn
                color="primary"
                :disabled="$v.icecast.$invalid"
                @click="step = 3"
              >
                <v-icon left>mdi-arrow-right</v-icon>
                {{ $t('continue') }}
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>
      </template>

      <template #content-3>
        <v-stepper-content step="3">
          <v-card flat color="transparent" class="mb-4">
            <v-card-text class="pa-0 pt-2">
              <v-checkbox
                class="ml-2"
                v-model="user.active"
                :label="$t('msg_station_user')"
                @input="$v.user.active.$touch()"
                @blur="$v.user.active.$touch()"
              ></v-checkbox>

              <v-text-field
                v-if="user.active"
                v-model="user.name"
                dense
                :label="$t('display_name')"
                outlined
                block
                @input="$v.user.name.$touch()"
                @blur="$v.user.name.$touch()"
              ></v-text-field>

              <v-text-field
                v-if="user.active"
                v-model="user.username"
                dense
                :label="$t('username')"
                outlined
                block
                @input="$v.user.username.$touch()"
                @blur="$v.user.username.$touch()"
              ></v-text-field>

              <v-text-field
                v-if="user.active"
                v-model="user.email"
                dense
                :label="$t('email')"
                outlined
                block
                @input="$v.user.email.$touch()"
                @blur="$v.user.email.$touch()"
              ></v-text-field>

              <v-text-field
                v-if="user.active"
                v-model="user.password"
                dense
                :label="$t('password')"
                outlined
                block
                :messages="$t('msg_password')"
                @input="$v.user.password.$touch()"
                @blur="$v.user.password.$touch()"
              ></v-text-field>
            </v-card-text>

            <v-card-actions class="pa-0 pt-2">
              <v-btn outlined color="primary" @click="step = 2">
                <v-icon left>mdi-arrow-left</v-icon>
                {{ $t('back') }}
              </v-btn>

              <v-btn color="primary" :disabled="$v.$invalid" @click="add">
                <v-icon left>mdi-plus-circle</v-icon>
                {{ $t('add_station') }}
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
  import { required, numeric, requiredIf, email } from 'vuelidate/lib/validators'
  import * as password from 'generate-password'

  @Component({
    meta: {
      admin: true,
    },
    head(this: AddStationPage): object {
      return {
        title: this.$t('add_station'),
      }
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
    user = {
      active: true,
      name: '',
      email: '',
      username: '',
      password: '',
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
      user: {
        active: { required },
        username: { required: requiredIf('active') },
        password: { required: requiredIf('active') },
        email: { required: requiredIf('active'), email },
        name: { required: requiredIf('active') },
      },
    }

    mounted() {
      this.icecast.password = password.generate({ length: 10, numbers: true })
      this.user.password = password.generate({ length: 10, numbers: true })
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
        user: this.user.active
          ? {
              name: this.user.name,
              username: this.user.username,
              email: this.user.email,
              password: this.user.password,
            }
          : null,
      })
      this.$router.push(this.localePath(`/stations/${station._id}`))
    }
  }
</script>
