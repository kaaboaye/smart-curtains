<template>
  <div id="app">
    <router-view />
    <Navigation></Navigation>
  </div>
</template>

<script>
import Navigation from "./components/Navigation";
export default {
  name: "app",
  components: {
    Navigation: Navigation
  }
};
</script>

<style>
* {
  box-sizing: padding-box;
}

html {
  width: 100%;
  height: 100%;
}

body {
  width: 100%;
  height: 100%;
  margin: 0;
}

a {
  text-decoration: none;
}

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: white;
  background: #232b2b;
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: column;
}
/*#nav {
  padding: 50px;
  margin: 40px;
}

#nav a {
  font-weight: bold;
  color: white;
  top: 2000px;
}

#nav a.router-link-exact-active {
  color: white;
}*/
</style>
