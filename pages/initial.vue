<template>
  <v-row align="center" justify="center">
    <v-col cols="12" class="text-center">
      <h2>ThRadio</h2>
    </v-col>
    <v-col cols="12">
      <v-stepper v-model="step">
        <v-stepper-header>
          <v-stepper-step :complete="step > 1" step="1">
            Configuration
          </v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step :complete="step > 2" step="2">
            Admin user
          </v-stepper-step>
        </v-stepper-header>

        <v-stepper-items>
          <v-stepper-content step="1">
            <v-card class="mb-12">
              <v-card-text>
                <v-text-field
                  v-model="config.name"
                  dense
                  label="Instance name"
                  outlined
                  block
                  @input="$v.config.name.$touch()"
                  @blur="$v.config.name.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="config.urlBase"
                  dense
                  label="Base URL of the site"
                  outlined
                  block
                  @input="$v.config.urlBase.$touch()"
                  @blur="$v.config.urlBase.$touch()"
                ></v-text-field>
              </v-card-text>
            </v-card>

            <v-btn
              color="primary"
              :disabled="$v.config.$invalid"
              @click="step = 2"
            >
              <v-icon left>mdi-arrow-right</v-icon>
              Continue
            </v-btn>
          </v-stepper-content>

          <v-stepper-content step="2">
            <v-card class="mb-12"
              ><v-card-text>
                <v-text-field
                  v-model="user.name"
                  dense
                  label="Display user name"
                  outlined
                  block
                  @input="$v.user.name.$touch()"
                  @blur="$v.user.name.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="user.email"
                  dense
                  label="Email"
                  outlined
                  block
                  @input="$v.user.email.$touch()"
                  @blur="$v.user.email.$touch()"
                ></v-text-field>
                <v-text-field
                  v-model="user.password"
                  dense
                  label="Password"
                  outlined
                  type="password"
                  block
                  @input="$v.user.password.$touch()"
                  @blur="$v.user.password.$touch()"
                ></v-text-field>
              </v-card-text>
            </v-card>

            <v-btn color="primary" @click="step = 1">
              <v-icon left>mdi-arrow-left</v-icon>
              Back
            </v-btn>

            <v-btn color="primary" :disabled="$v.$invalid" @click="save">
              <v-icon left>mdi-radio</v-icon>
              Save
            </v-btn>
          </v-stepper-content>
        </v-stepper-items>
      </v-stepper>
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
          email: this.user.email,
          password: this.user.password,
        },
      })
      await this.$store.dispatch('getConfig')
      await this.$router.push('/login')
    }
  }
</script>
