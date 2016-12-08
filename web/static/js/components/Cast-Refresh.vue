<template>
  <button type="button" name="refresh" v-on:click="refresh" :disabled="disabled" class="btn btn-primary">
    {{ state }} {{ name }}
  </button>
</template>

<script>


export default {
  props: {
    name: String
  },

  data () {
    return {
      state: "Refresh",
      disabled: false
    }
  },


  methods: {
    refresh: function() {
      this.disabled = true;
      this.state = "Refreshing";
      this.$parent.casts = [];

      this.$http.put('/refreshes/' + this.name)
        .then(response => {
          this.disabled = false;
          this.state = "Refresh";
          this.$parent.casts = response.data.casts;
        }, error => {
          this.$dispatch('toast-msg', "Could not refresh")
        })
    }
  }
}
</script>
