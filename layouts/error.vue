<template>
  <v-row align="center" justify="center">
    <v-col>
      <v-card>
        <v-card-title v-if="error.statusCode === 404" primary-title>
          <v-spacer />
          {{ pageNotFound }}
          <v-spacer />
        </v-card-title>
        <v-card-title v-else primary-title>
          <v-spacer />
          {{ otherError }}
          <v-spacer />
        </v-card-title>
        <v-card-actions class="pa-5">
          <v-btn to="/" block color="primary">Home page</v-btn>
        </v-card-actions>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
  export default {
    layout: 'blank',
    props: {
      error: {
        type: Object,
        default: null,
      },
    },
    data() {
      return {
        pageNotFound: '404 Not Found',
        otherError: 'An error occurred',
      }
    },
    head() {
      const title =
        this.error.statusCode === 404 ? this.pageNotFound : this.otherError
      return {
        title,
      }
    },
  }
</script>
