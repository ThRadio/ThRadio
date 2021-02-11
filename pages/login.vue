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
          <h3>Login</h3>
        </v-card-subtitle>
        <v-card-text>
          <v-text-field
            v-model="login.email"
            dense
            label="Email"
            outlined
            block
            type="email"
            @input="$v.login.email.$touch()"
            @blur="$v.login.email.$touch()"
          ></v-text-field>
          <v-text-field
            v-model="login.password"
            dense
            label="Password"
            outlined
            type="password"
            block
            @input="$v.login.password.$touch()"
            @blur="$v.login.password.$touch()"
          ></v-text-field>
          <v-btn
            :disabled="$v.$invalid"
            depressed
            block
            color="primary"
            @click="userLogin()"
            >Login</v-btn
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
import { required, email } from 'vuelidate/lib/validators'

@Component({
  auth: 'guest',
  layout: 'blank',
  head: {
    title: 'Login',
  },
})
export default class LoginPage extends Vue {
  loading = false
  login = {
    email: '',
    password: '',
  }

  @Validations()
  validations = {
    login: {
      email: { required, email },
      password: { required },
    },
  }

  async userLogin() {
    try {
      this.loading = true
      await this.$auth.loginWith('local', { data: this.login })
      this.$router.push('/')
    } catch (err) {
      console.log(err)
    }
  }
}
</script>
