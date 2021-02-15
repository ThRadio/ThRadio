<template>
  <div class="ConfigPage">
    <v-card>
      <v-card-title>
        <h4>Configuration</h4>
      </v-card-title>
      <v-card-text>
        <v-text-field
          v-model="name"
          dense
          label="Instance name"
          outlined
          block
          @input="$v.name.$touch()"
          @blur="$v.name.$touch()"
        ></v-text-field>
        <v-text-field
          v-model="urlBase"
          dense
          label="Base URL of the site"
          outlined
          block
          @input="$v.urlBase.$touch()"
          @blur="$v.urlBase.$touch()"
        ></v-text-field>
        <v-btn
          :disabled="$v.$invalid"
          depressed
          block
          color="primary"
          @click="update"
        >
          <v-icon left>mdi-pencil</v-icon>
          Update
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
          Close
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
    head: {
      title: 'Config',
    },
  })
  export default class ConfigPage extends Vue {
    loading = false
    name: string = ''
    urlBase: string = ''

    snackbar = {
      show: false,
      text: '',
    }

    @Validations()
    validations = {
      name: { required },
      urlBase: { required },
    }

    mounted() {
      this.name = this.$store.getters.config.name
      this.urlBase = this.$store.getters.config.url_base
    }

    async update() {
      try {
        this.loading = true
        await this.$axios.$put('/api/app/config', {
          name: this.name,
          url_base: this.urlBase,
        })
        this.loading = false
        await this.$store.dispatch('getConfig')
        this.snackbar.show = true
        this.snackbar.text = 'Successfully update'
      } catch (err) {
        console.log(err)
      }
    }
  }
</script>
