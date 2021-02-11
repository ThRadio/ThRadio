<template>
  <v-row align="center" justify="center">
    <v-col>
      <v-card>
        <v-card-title>
          <v-spacer></v-spacer>
          <h4>ThRadio</h4>
          <v-spacer></v-spacer>
        </v-card-title>
        <v-card-subtitle class="text-center">
          <h3>Initial configuration</h3>
        </v-card-subtitle>
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
          <v-btn
            :disabled="$v.$invalid"
            depressed
            block
            color="primary"
            @click="save()"
            >Save</v-btn
          >
        </v-card-text>
      </v-card>
    </v-col>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
  </v-row>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
import { Validations } from 'vuelidate-property-decorators'
import { required } from 'vuelidate/lib/validators'

@Component({
  auth: 'guest',
  layout: 'blank',
  head: {
    title: 'Initial',
  },
})
export default class InitialPage extends Vue {
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

  @Validations()
  validations = {
    config: {
      name: { required },
      urlBase: { required },
    },
    user: {
      name: { required },
      email: { required },
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
    this.$router.push('/')
  }
}
</script>
