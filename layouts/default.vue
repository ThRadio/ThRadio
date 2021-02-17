<template>
  <v-app dark>
    <v-navigation-drawer v-model="drawer" clipped fixed app>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="title">
            {{ $auth.user.name }}
          </v-list-item-title>
          <v-list-item-subtitle>
            {{ $auth.user.email }}
          </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <div class="pa-2">
        <v-btn
          rounded
          color="red"
          class="ma-0"
          block
          small
          size="large"
          @click="logout"
        >
          <v-icon left>mdi-logout-variant</v-icon>
          Log out
        </v-btn>
      </div>

      <v-divider></v-divider>

      <v-list nav dense>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar clipped-left fixed app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title
        >ThRadio - {{ $store.getters.config.name }}</v-toolbar-title
      >
    </v-app-bar>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <Footer></Footer>
  </v-app>
</template>

<script lang="ts">
  import { Component, Vue } from 'nuxt-property-decorator'

  @Component
  export default class DefaultLayout extends Vue {
    drawer = null
    items = [
      {
        icon: 'mdi-home',
        title: 'Home',
        to: '/',
      },
      {
        icon: 'mdi-cog-outline',
        title: 'Config',
        to: '/config',
      },
    ]

    async logout() {
      await this.$auth.logout()
      this.$router.push('/login')
    }
  }
</script>
