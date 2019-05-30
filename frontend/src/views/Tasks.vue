<template>
  <div id="Tasks">
    <ul class="task_button">
      <li v-for="task in tasks" v-bind:key="task">
        <router-link :to="{name: 'edit'}">
          <button class="button">{{task}}</button>
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "app",
  data: function() {
    return {
      tasks: {
        key1: "Please",
        key2: "Say",
        key3: "That my app",
        key4: "Is really, really nice"
      }
    };
  }
};
</script>

<style>
.task_button li {
  list-style: none;
  background: blue;
  width: 100%;
  display: block;
}

.task_button button {
  width: 100%;
  height: 50px;
  display: block;
  border: none;
  padding: 14px 28px;
  font-size: 16px;
  cursor: pointer;
  text-align: center;
  background-color: #232b2b;
  color: white;
  border: 1px solid white;
}

#Tasks {
  margin-top: auto;
  margin-bottom: auto;
  display: flex;
  justify-content: center;
  width: 100%;
}

.button {
  border-color: white;
  display: block;
  width: 100%;
}
</style>
