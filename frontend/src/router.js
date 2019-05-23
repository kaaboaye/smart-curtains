import Vue from "vue";
import Router from "vue-router";
import Home from "./views/Home.vue";
import Tasks from "./views/Tasks.vue";
import Task from "./views/Task.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "home",
      component: Home
    },
    {
      path: "/tasks",
      name: "tasks",
      component: Tasks
    },
    {
      path: "/task/:taskId",
      name: "task",
      component: Task
    }
  ]
});
