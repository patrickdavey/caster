// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {
  logger: ((kind, msg, data) => { console.log("stuff") })
})

socket.connect({user_id: "123"})
socket.onOpen( ev => console.log("OPEN", ev) )
socket.onError( ev => console.log("ERROR", ev) )
socket.onClose( e => console.log("CLOSE", e))

var chan = socket.channel("cast:lobby", {})
chan.join().receive("ignore", () => console.log("auth error"))
           .receive("ok", () => console.log("join ok"))

chan.onError(e => console.log("something went wrong", e))
chan.onClose(e => console.log("channel closed", e))
chan.on("new:msg", msg => {
  console.log(msg);
});
