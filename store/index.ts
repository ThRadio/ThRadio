import { GetterTree, ActionTree, MutationTree } from 'vuex'
export const state = () => ({
  config: {} as Object,
})
export type RootState = ReturnType<typeof state>

export const getters: GetterTree<RootState, RootState> = {
  config: (state) => state.config,
}
export const mutations: MutationTree<RootState> = {
  CHANGE_CONFIG: (state, newVal: number) => (state.config = newVal),
}
export const actions: ActionTree<RootState, RootState> = {
  async nuxtServerInit({ commit }) {
    const config = await this.$axios.$get('/api/app/config')
    commit('CHANGE_CONFIG', config)
  },
  async getConfig({ commit }) {
    const config = await this.$axios.$get('/api/app/config')
    commit('CHANGE_CONFIG', config)
  },
}
