<template>
  <v-row align="center" justify="center">
    <v-col cols="12">
      <Stepper :value="step" :steps="2">
        <!-- Title -->
        <template #title>
          <v-card-title primary-title>
            <v-spacer />
            ThRadio
            <v-spacer />
          </v-card-title>
        </template>

        <!-- Titles steps -->
        <template #step-1>
          <v-stepper-step :complete="step > 1" step="1">
            {{ $t('configuration') }}
          </v-stepper-step>
        </template>
        <template #step-2>
          <v-stepper-step :complete="step > 2" step="2">
            {{ $t('admin_user') }}
          </v-stepper-step>
        </template>

        <!-- Content steps -->
        <template #content-1>
          <v-stepper-content step="1">
            <v-card flat color="transparent" class="mb-4">
              <v-card-text class="pa-0 pt-2">
                <v-text-field
                  v-model="config.name"
                  dense
                  :label="$t('instance_name')"
                  outlined
                  block
                  @input="$v.config.name.$touch()"
                  @blur="$v.config.name.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="config.urlBase"
                  dense
                  :label="$t('url_base')"
                  outlined
                  block
                  @input="$v.config.urlBase.$touch()"
                  @blur="$v.config.urlBase.$touch()"
                ></v-text-field>
              </v-card-text>
              <v-card-actions class="pa-0 pt-2">
                <v-btn
                  color="primary"
                  :disabled="$v.config.$invalid"
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
                  v-model="user.name"
                  dense
                  :label="$t('display_name')"
                  outlined
                  block
                  @input="$v.user.name.$touch()"
                  @blur="$v.user.name.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="user.username"
                  dense
                  :label="$t('username')"
                  outlined
                  block
                  @input="$v.user.username.$touch()"
                  @blur="$v.user.username.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="user.email"
                  dense
                  :label="$t('email')"
                  outlined
                  block
                  @input="$v.user.email.$touch()"
                  @blur="$v.user.email.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="user.password"
                  dense
                  :label="$t('password')"
                  outlined
                  type="password"
                  block
                  @input="$v.user.password.$touch()"
                  @blur="$v.user.password.$touch()"
                ></v-text-field>
              </v-card-text>
              <v-card-actions class="pa-0 pt-2">
                <v-btn outlined color="primary" @click="step = 1">
                  <v-icon left>mdi-arrow-left</v-icon>
                  {{ $t('back') }}
                </v-btn>

                <v-btn color="primary" :disabled="$v.$invalid" @click="save">
                  <v-icon left>mdi-radio</v-icon>
                  {{ $t('save') }}
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-stepper-content>
        </template>
      </Stepper>
    </v-col>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </v-row>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'
  import { Validations } from 'vuelidate-property-decorators'
  import { required, email } from 'vuelidate/lib/validators'

  @Component({
    auth: 'guest',
    layout: 'blank',
    head: {
      title: 'Initial',
    },
  })
  export default class InitialPage extends Vue {
    step = 1
    loading = false
    config = {
      name: '',
      urlBase: '',
    }

    user = {
      name: '',
      username: '',
      email: '',
      password: '',
    }

    mounted() {
      this.config.urlBase = `${window.location.protocol}//${window.location.host}`
    }

    @Validations()
    validations = {
      config: {
        name: { required },
        urlBase: { required },
      },
      user: {
        name: { required },
        username: { required },
        email: { required, email },
        password: { required },
      },
    }

    async save() {
      this.loading = true
      await this.$axios.$post('/api/app/initial', {
        config: {
          name: this.config.name,
          url_base: this.config.urlBase,
        },
        user: {
          name: this.user.name,
          username: this.user.username,
          email: this.user.email,
          password: this.user.password,
        },
      })
      await this.$store.dispatch('getConfig')
      await this.$router.push('/login')
    }
  }
</script>
