<template>
  <div class="EditPage">
    <v-card>
      <v-app-bar flat color="rgba(0, 0, 0, 0)">
        <v-btn :to="`/stations/${station._id}`" icon>
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <v-toolbar-title class="title white--text pl-0">
          Edit station
        </v-toolbar-title>
      </v-app-bar>
      <v-card-text>
        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="name"
              dense
              label="Name"
              outlined
              block
              @input="$v.name.$touch()"
              @blur="$v.name.$touch()"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="icecastPassword"
              dense
              label="Password icecast"
              outlined
              block
              @input="$v.icecastPassword.$touch()"
              @blur="$v.icecastPassword.$touch()"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="icecastPort"
              dense
              label="Port icecast"
              outlined
              block
              @input="$v.icecastPort.$touch()"
              @blur="$v.icecastPort.$touch()"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-btn
              :disabled="$v.$invalid"
              depressed
              block
              color="primary"
              @click="edit()"
            >
              Edit station
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator'
import { Validations } from 'vuelidate-property-decorators'
import { required } from 'vuelidate/lib/validators'

@Component({
  head(this: EditPage): object {
    return {
      title: `Edit ${this.station.name}`,
    }
  },
})
export default class EditPage extends Vue {
  station: any
  name: string = ''
  icecastPassword: string = ''
  icecastPort: string = ''

  @Validations()
  validations = {
    name: { required },
    icecastPassword: { required },
    icecastPort: { required },
  }

  async asyncData({ $axios, params }: any) {
    const station = await $axios.$get(`/api/stations/${params.id}`)
    return { station }
  }

  mounted() {
    this.name = this.station.name
    this.icecastPassword = this.station.icecast_password
    this.icecastPort = this.station.icecast_port
  }

  async edit() {
    await this.$axios.$put(`/api/stations/${this.$route.params.id}`, {
      name: this.name,
      icecast_password: this.icecastPassword,
      icecast_port: this.icecastPort,
    })
    this.$router.push(`/stations/${this.$route.params.id}`)
  }
}
</script>
