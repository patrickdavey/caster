<template>
  <tr>
    <td>
      <span
        class="glyphicon interesting"
        v-on:click="toggleInteresting"
        v-bind:class="{ 'glyphicon-star': cast.interesting, 'glyphicon-star-empty': !cast.interesting }"
      aria-hidden="true"></span>

      <a v-if="fileExists" :href="showPath" v-on:click.stop.prevent="launchVideo">{{ cast.title }}</a>
      <span v-else>{{ cast.title }}</span>
    </td>
    <td>
      <template v-if="showRemove() === true">
        <button type="button" v-on:click="removeDownload" class="btn btn-danger" name="removeDownload">
          Remove Download
        </button>
      </template>

      <template v-if="cast.state === 'fresh'">
        <button type="button" name="download" v-on:click="download" class="btn btn-primary">
          <span class="glyphicon glyphicon-download" aria-hidden="true"></span> Download
        </button>
      </template>

      <template v-if="cast.state === 'downloading'">
        Downloading...
        <i class="fa fa-spin fa-spinner" aria-hidden="true"></i>
      </template>

      <button class="btn btn-default"
        @click="openModal"
        >{{ noteText }}
      </button>
    </td>
  </tr>
</template>

<script>

import Vue from 'vue'

export default Vue.extend({
  props: {
    removeable: Boolean,
    cast: Object
  },

  computed: {
    showPath: function() {
      return '/casts/' + this.cast.id;
    },
    noteText: function() {
      if (this.cast.note) {
        return "Edit Note";
      }

      return "Create Note";
    },
    fileExists: function () {
      return this.cast.state === "downloaded" || this.cast.state === "viewed"
    }
  },

  methods: {
    launchVideo: function() {
      this.$http.get('/casts/' + this.cast.id);
    },

    openModal: function () {
      this.$parent.showModal = true;
      this.$parent.selectedCast = this.cast;
    },
    downloadStarted: function () {
      this.cast.state = 'downloading'
      this.$dispatch('toast-msg', "starting download")
    },
    download: function() {
      let chan = this.$socket.channel("casts:cast" + this.cast.id, {});
      chan.join();
      chan.on("downloaded", msg => {
        this.cast.state = 'downloaded';
        chan.leave()
      });
      this.$http.post('/casts/' + this.cast.id + '/downloads')
        .then(response => {
          this.downloadStarted();
        }, error => {
          this.$dispatch('toast-msg', "Could not download cast")
        })
    },
    removeDownload: function() {
      this.$http.delete('/casts/' + this.cast.id + '/downloads')
        .then(response => {
          this.downloadRemoved();
        }, error => {
          this.$dispatch('toast-msg', "Could not remove download")
        })
    },
    downloadRemoved: function () {
      this.cast.state = 'fresh'
      this.$dispatch('toast-msg', "Removed download")
    },

    showRemove: function () {
      return this.removeable && (this.cast.state === 'viewed' || this.cast.state === 'downloaded');
    },

    toggleInteresting: function () {
      this.$http.put('/casts/' + this.cast.id, { cast: { interesting: !this.cast.interesting } })
        .then(response => {
          this.cast.interesting = !this.cast.interesting;
        }, error => {
          this.$dispatch('toast-msg', "Could not toggle interesting")
        })
    },
  }
})
</script>
