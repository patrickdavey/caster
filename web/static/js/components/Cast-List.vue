<template>
  <div class="cast-list">
    <h1>{{ title }}</h1>
    <cast-refresh v-if="refreshable" :name="castType()" ></cast-refresh>
    <div v-if="initialFetchComplete">
      <div v-if="error">
        <strong>Error!</strong> {{ error }}
      </div>
      <div v-if="hasInterestingCasts">
        <h2>Interesting items</h2>
        <table class="interesting table">
          <thead>
            <tr>
              <th>Name</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr is="cast" :removeable="removeable" :cast="cast" v-for="cast in interestingCasts"></tr>
          </tbody>
        </table>
      </div>

      <div v-if="hasNormalCasts">
        <h2>Other items</h2>
        <table class="normal table">
          <thead>
            <tr>
              <th>Name</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr is="cast" :cast="cast" :removeable="removeable" v-for="cast in normalCasts"></tr>
          </tbody>
        </table>
      </div>
    </div>
    <p v-else>Loading...</p>

    <modal :callback="saveNote" @cancel="showModal = false" :value.sync="showModal">
      <div slot="modal-header" class="modal-header">
        <h4 class="modal-title">Notes for {{ selectedCast.title }}</h4>
      </div>
      <div slot="modal-body" class="modal-body">
        <textarea name="note" class="form-control" rows="15" v-model="selectedCast.note"></textarea>
      </div>
    </modal>
  </div>
</template>

<script>
  import Cast from './Cast.vue'
  import CastRefresh from './Cast-Refresh.vue'
  import {modal} from 'vue-strap/dist/vue-strap.min'
  import Vue from 'vue'
  import { EventBus } from '../event-bus.js';


  export default Vue.extend({
    data () {
      return {
        casts: [],
        title: "",
        showModal: false,
        selectedCast: { title: "", note: "" },
        error: null,
        initialFetchComplete: false,
      }
    },

    props: {
      refreshable: {
        type: Boolean,
        default: false
      },
    },

    computed: {
      hasInterestingCasts () {
        return this.casts.filter((c) => c.interesting === true).length > 0
      },
      hasNormalCasts () {
        return this.casts.filter((c) => c.interesting === false).length > 0
      },
      interestingCasts: function () {
        var self = this;
        return self.casts.filter(function (cast) {
          return cast.interesting == true;
        })
      },
      normalCasts: function () {
        var self = this;
        return self.casts.filter(function (cast) {
          return cast.interesting == false;
        })
      }
    },

    components: {
      Cast,
      CastRefresh,
      modal
    },

    created: function() {
      this.fetchCasts()
    },

    methods: {
      castType () {
        return window.source || 'customcast';
      },

      saveNote: function () {
        this.$http.put('/casts/' + this.selectedCast.id,
          { cast: { note: this.selectedCast.note }})
          .then(response => {
            this.showModal = false;
          }, error => {
            EventBus.$emit('toast-msg', "Could not update note");
          })
      },

      cancelPressed: function () {
        debugger;
      },

      fetchCasts () {
        this.$http.get('/casts?source=' + this.castType())
        .then(response => {
          this.error = null;
          this.casts = response.data.casts;
          this.removeable = response.data.removeable;
          this.title = response.data.title;
          this.refreshable = response.data.refreshable;
          this.initialFetchComplete = true;
        }, error => {
          EventBus.$emit('toast-msg', "Could not fetch casts from server!");
          this.initialFetchComplete = true;
        })
      },
    }
  })
</script>
