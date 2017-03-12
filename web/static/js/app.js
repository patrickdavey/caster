// VENDOR
import Vue from 'vue'
import VueResource from 'vue-resource'
import PhoenixVueSocket from './plugins/Phoenix-Vue-Socket'

// COMPONENTS
import CastList from './components/Cast-List.vue'
import VueToast from 'vue-toast'
import { EventBus } from './event-bus.js';

// PLUGINS
Vue.use(VueResource)
Vue.use(PhoenixVueSocket)

let csrf = document.querySelector('meta[name="csrf-token"]');

if (csrf) {
  Vue.http.headers.common['X-CSRF-Token'] = csrf.getAttribute('content')
}
Vue.http.headers.common['Accept'] = 'application/json';

//GLOBAL COMPONENT
new Vue({
  el: '#cast-list',
  components: {
    CastList: CastList
  }
});

new Vue({
  el: '#toast',
  components: {
    VueToast: VueToast
  },
  mounted() {
    const toast = this.$refs.toast;

    toast.setOptions({
      timeLife: 3000,
      position: 'top right'
    });

    EventBus.$on('toast-msg', function(msg) {
      toast.showToast(msg);
    });
    //setup toast object and cache it. Unsure if this is best practice.
  }
})
