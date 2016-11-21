import {Socket} from "phoenix"

export default {
  install(Vue){
    let socket = new Socket("/socket", {})

    socket.connect()

    Vue.prototype.$socket = socket;
  }
}
