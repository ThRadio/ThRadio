<template>
  <div class="EditStationPage">
    <Stepper :step="step" :steps="3">
      <!-- Title -->
      <template #title>
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-btn :to="localePath(`/stations/${station._id}`)" icon>
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <v-toolbar-title class="title white--text pl-0">
            {{ $t('edit_station') }}
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
          {{ $t('information') }}
          <small v-if="$v.information.$invalid">{{ $t('incomplete') }}</small>
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
          <small v-if="$v.icecast.$invalid">{{ $t('incomplete') }}</small>
        </v-stepper-step>
      </template>

      <template #step-3>
        <v-stepper-step
          :rules="[() => !$v.user.$invalid]"
          editable
          :complete="!$v.user.$invalid"
          step="3"
        >
          {{ $t('user') }}
          <small v-if="$v.user.$invalid">{{ $t('incomplete') }}</small>
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
              ></v-text-field>

              <v-textarea
                v-model="information.description"
                outlined
                dense
                :label="$t('description')"
                :hint="$t('optional')"
                @input="$v.information.description.$touch()"
                @blur="$v.information.description.$touch()"
              ></v-textarea>

              <v-text-field
                v-model="information.genre"
                outlined
                dense
                block
                :label="$t('genre')"
                :hint="$t('optional')"
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
                :hint="`${$t('optional')} (${$t('default')} 250)`"
                @input="$v.icecast.listeners.$touch()"
                @blur="$v.icecast.listeners.$touch()"
              ></v-text-field>
            </v-card-text>
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
                @change="newCheck"
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
                :messages="user.new ? '' : $t('msg_change_password')"
                @input="$v.user.password.$touch()"
                @blur="$v.user.password.$touch()"
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
      {{ $t('edit_station') }}
    </v-btn>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </div>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'
  import { Validations } from 'vuelidate-property-decorators'
  import { required, numeric, requiredIf, email } from 'vuelidate/lib/validators'

  @Component({
    head(this: EditStationPage): object {
      return {
        title: `${this.$t('edit')} ${this.station.name}`,
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
    user = {
      active: false,
      new: false,
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
        new: { required },
        username: { required: requiredIf('active') },
        password: { required: requiredIf('new') },
        email: { required: requiredIf('active'), email },
        name: { required: requiredIf('active') },
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
      if (this.station.user) {
        this.user.active = true
        this.user.name = this.station.user.name
        this.user.email = this.station.user.email
        this.user.username = this.station.user.username
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
        user: this.user.active
          ? {
              name: this.user.name,
              username: this.user.username,
              email: this.user.email,
              password: this.user.password,
            }
          : null,
      })
      this.$router.push(this.localePath(`/stations/${this.$route.params.id}`))
    }

    newCheck() {
      if (!this.station.user) this.user.new = true
      if (!this.user.active) this.user.new = false
    }
  }
</script>
