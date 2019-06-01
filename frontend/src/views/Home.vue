<template>
  <div class="slider-container">
    <vue-slider v-model="value" direction="ttb" :height="300" :width="50"/>
  </div>
</template>

<script>
import VueSlider from "vue-slider-component";
import "vue-slider-component/theme/antd.css";

export default {
  components: {
    VueSlider
  },

  data() {
    return {
      value: 0
    };
  }
};
</script>

<style>
.vue-slider-rail {
  background: white;
  background-image: linear-gradient(#ffc107, #7d8a73, #607d8b);
}

.vue-slider-dot {
  width: 100% !important;
  border-radius: 0;
}

.vue-slider-dot-handle {
  border-radius: 0;
  background: #03a9f4;
  outline: none;
}
</style>
