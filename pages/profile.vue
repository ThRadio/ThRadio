<template>
  <div class="ProfilePage">
    <v-card>
      <v-card-title>
        <h4>{{ $t('profile') }}</h4>
      </v-card-title>
      <v-card-text>
        <v-text-field
          v-model="name"
          dense
          :label="$t('display_name')"
          outlined
          block
          @input="$v.name.$touch()"
          @blur="$v.name.$touch()"
        ></v-text-field>
        <v-text-field
          v-model="username"
          dense
          :label="$t('username')"
          outlined
          :disabled="!$auth.hasScope('admin')"
          block
          @input="$v.username.$touch()"
          @blur="$v.username.$touch()"
        ></v-text-field>
        <v-text-field
          v-model="email"
          dense
          :label="$t('email')"
          outlined
          block
          @input="$v.email.$touch()"
          @blur="$v.email.$touch()"
        ></v-text-field>
        <v-text-field
          v-model="password"
          dense
          :label="$t('password')"
          outlined
          block
          :messages="$t('msg_change_password')"
          @input="$v.password.$touch()"
          @blur="$v.password.$touch()"
        ></v-text-field>
        <v-btn
          :disabled="$v.$invalid"
          depressed
          block
          color="primary"
          @click="update"
        >
          <v-icon left>mdi-pencil</v-icon>
          {{ $t('update') }}
        </v-btn>
      </v-card-text>
    </v-card>

    <v-overlay :value="loading">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>

    <v-snackbar v-model="snackbar.show" :timeout="3000">
      {{ snackbar.text }}

      <template #action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar.show = false">
          {{ $t('close') }}
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
import { Validations } from 'vuelidate-property-decorators'
import { required } from 'vuelidate/lib/validators'

@Component({
  head(this: ProfilePage): object {
    return {
      title: this.$t('profile'),
    }
  },
})
export default class ProfilePage extends Vue {
  loading = false
  name: string = ''
  username: string = ''
  email: string = ''
  password: string = ''

  snackbar = {
    show: false,
    text: '',
  }

  @Validations()
  validations = {
    name: { required },
    username: { required },
    email: { required },
    password: {},
  }

  mounted() {
    const user: any = this.$auth?.user
    this.name = user.name
    this.username = user.username
    this.email = user.email
  }

  async update() {
    try {
      this.loading = true
      await this.$axios.$put('/api/auth/me', {
        name: this.name,
        username: this.username,
        email: this.email,
        password: this.password,
      })
      this.loading = false
      await this.$auth.fetchUser()
      this.snackbar.show = true
      this.snackbar.text = this.$t('msg_success').toString()
    } catch (err) {
      console.log(err)
    }
  }
}
</script>
