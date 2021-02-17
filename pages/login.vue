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
          <h3>{{ $t('login') }}</h3>
        </v-card-subtitle>
        <v-card-text>
          <v-text-field
            v-model="login.username"
            dense
            :label="$t('username')"
            outlined
            block
            @input="$v.login.username.$touch()"
            @blur="$v.login.username.$touch()"
          ></v-text-field>
          <v-text-field
            v-model="login.password"
            dense
            :label="$t('password')"
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
          >
            <v-icon left>mdi-login-variant</v-icon>
            {{ $t('login') }}
          </v-btn>
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
    head(this: LoginPage): object {
      return {
        title: this.$t('login'),
      }
    },
  })
  export default class LoginPage extends Vue {
    loading = false
    login = {
      username: '',
      password: '',
    }

    @Validations()
    validations = {
      login: {
        username: { required },
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
