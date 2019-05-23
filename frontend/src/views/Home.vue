<template>
  <div class="slider-container">
    <vue-slider v-model="value" direction="ttb" :height="400" :width="50" v-on:change="dupa"/>
  </div>
</template>

<script>
import VueSlider from "vue-slider-component";
import "vue-slider-component/theme/antd.css";

export default {
  components: {
    VueSlider
  },
  methods: {
    dupa: function(e) {
      console.log("dupa", e);
    }
  },
  data() {
    return {
      value: 0
    };
  }
};
</script>

<style>
.slider-container {
  margin-top: auto;
  margin-bottom: auto;
  display: flex;
  justify-content: center;
}

.vue-slider-rail {
  background: #fff;
}

.vue-slider-dot {
  width: 100% !important;
  border-radius: 0;
}

.vue-slider-dot-handle {
  border-radius: 0;
  background: #03a9f4;
}
</style>

