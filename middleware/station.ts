import { Middleware } from '@nuxt/types'

const station: Middleware = async (context) => {
  const user: any = context.$auth.user
  if (context.route.meta[0].admin && context.$auth.hasScope('station'))
    if (context.route.path !== `/stations/${user.station}`) {
      context.redirect(`/stations/${user.station}`)
    }

}

export default station
