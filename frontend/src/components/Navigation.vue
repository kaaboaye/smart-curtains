<template>
  <nav class="nav">
    <router-link :to="{name: 'home'}">
      <button class="nav__button">
        <img src="../assets/sunny.svg">
        <span class="nav__link">Current setting</span>
      </button>
    </router-link>
    <router-link :to="{name: 'tasks'}">
      <button class="nav__button">
        <img src="../assets/schedule.svg">
        <span class="nav__link">Tasks</span>
      </button>
    </router-link>
  </nav>
</template>

<script>
export default {
  name: "Navigation"
};
</script>

<style>
.nav {
  padding-top: 5px;
  position: absolute;
  bottom: 0;
  display: flex;
  justify-content: space-evenly;
  border-top: 1px solid #707070;
  width: 100%;
}
.nav__button {
  text-decoration: none;
  background: none;
  border: none;
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
}

.nav__button img {
  height: 50px;
}

.nav__link {
  margin-top: 9px;
  color: white;
  font-size: 14px;
}
</style>
