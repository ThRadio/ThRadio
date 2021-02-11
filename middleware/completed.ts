import { Middleware } from '@nuxt/types'

const completed: Middleware = async (context) => {
  const data = await context.$axios.$get('/api/app/completed')
  if (data.config === false || data.user === false) {
    if (context.route.path !== '/initial') {
      context.redirect('/initial')
    }
  }
}

export default completed
