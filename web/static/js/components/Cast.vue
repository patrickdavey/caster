<template>
  <tr>
    <td>
      <span
        class="glyphicon interesting"
        v-on:click="toggleInteresting"
        v-bind:class="{ 'glyphicon-star': cast.interesting, 'glyphicon-star-empty': !cast.interesting }"
      aria-hidden="true"></span>

      <a v-if="fileExists" :href="showPath">{{ cast.title }}</a>
      <span v-else>{{ cast.title }}</span>
    </td>
    <td>
      <template v-if="cast.state === 'viewed'">
        <button type="button" v-on:click="removeDownload" class="btn btn-danger" name="removeDownload">
          Remove Download
        </button>
      </template>
      <template v-if="cast.state === 'downloaded'">
        <button type="button" v-on:click="removeDownload" name="removeDownload" class="btn btn-danger">
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
    openModal: function () {
      this.$parent.showModal = true;
      this.$parent.selectedCast = this.cast;
    },
    downloadStarted: function () {
      this.cast.state = 'downloading'
      this.$dispatch('toast-msg', "starting download")
    },
    download: function() {
      this.$http.post('/items/' + this.cast.id + '/download.json')
        .then(response => {
          this.downloadStarted();
        }, error => {
          this.$dispatch('toast-msg', "Could not download cast")
        })
    },
    removeDownload: function() {
      this.$http.post('/items/' + this.cast.id + '/remove_download.json')
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
