// VENDOR
import Vue from 'vue'
import VueResource from 'vue-resource'

// COMPONENTS
import CastList from './components/Cast-List.vue'
import VueToast from 'vue-toast'
import { socket } from './socket';

// PLUGINS
Vue.use(VueResource)

let csrf = document.querySelector('meta[name="csrf-token"]');

if (csrf) {
  Vue.http.headers.common['X-CSRF-Token'] = csrf.getAttribute('content')
}
Vue.http.headers.common['Accept'] = 'application/json';

//GLOBAL COMPONENT
new Vue({
  el: 'body',
  components: {
    CastList: CastList,
    VueToast: VueToast
  },
  events: {
    'toast-msg': function (msg) {
      this.toast.showToast(msg);
    }
  }, ready: function () {
    //setup toast object and cache it. Unsure if this is best practice.
    const toast = this.$refs.toast;
    this.toast = toast;
    this.toast.setOptions({ position: 'top right' });
  }
})
