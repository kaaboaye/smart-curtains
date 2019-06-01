<template>
  <div>
    <div class="timer-container">
      <timeselector class="tS" v-model="time"></timeselector>
    </div>
    <div class="slider-container">
      <vue-slider v-model="value" direction="ttb" :height="300" :width="50"/>
    </div>
  </div>
</template>

<script>
import VueSlider from "vue-slider-component";
import "vue-slider-component/theme/antd.css";
import Timeselector from "vue-timeselector";

export default {
  name: "Edit",
  components: {
    VueSlider,
    Timeselector
  },
  data() {
    return {
      value: 0,
      time: null
    };
  }
};
</script>

<style>
.hello {
  display: inline-block;
}

.content-wrapper {
  height: 70vh;
}

.slider-container {
  padding: 109px 0;
  margin-top: auto;
  margin-bottom: auto;
  display: flex;
  justify-content: center;
  position: relative;
}

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

.timer.container {
  display: flex;
  position: relative;
  bottom: 10px;
}

.tS {
  color: black;
  margin-top: 10px;
}
</style>
