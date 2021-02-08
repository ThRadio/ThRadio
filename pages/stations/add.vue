<template>
  <div class="AddStationPage">
    <v-card>
      <v-card-title primary-title> Add station </v-card-title>
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
              @click="add()"
            >
              Add station
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
      title: 'Add station',
    }
  },
})
export default class EditPage extends Vue {
  name: string = ''
  icecastPassword: string = ''
  icecastPort: string = ''

  @Validations()
  validations = {
    name: { required },
    icecastPassword: { required },
    icecastPort: { required },
  }

  async add() {
    const station = await this.$axios.$post('/api/stations', {
      name: this.name,
      icecast_password: this.icecastPassword,
      icecast_port: this.icecastPort,
    })
    this.$router.push(`/stations/${station._id}`)
  }
}
</script>
