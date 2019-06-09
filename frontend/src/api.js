import axios from "axios";
import moment from "moment";

function url(path) {
  return `/api${path}`;
}

export function getCurrentState() {
  return axios
    .get(url("/settings/custom_desired_value"))
    .then(r => r.data.data.value)
    .catch(console.log);
}

export function getLightReading() {
  return axios
    .get(url("/settings/light_reading"))
    .then(
      ({
        data: {
          data: { value }
        }
      }) => value
    )
    .catch(console.log);
}

export function createTask() {
  return axios
    .post(url("/tasks"), {
      task: { scheduled_at: "12:00:00", desired_value: 50 }
    })
    .then(({ data: { data: task } }) => task)
    .catch(console.log);
}

export function getTasks() {
  return axios
    .get(url("/tasks"))
    .then(r => r.data.data)
    .catch(console.log);
}

export function updateCurrentSetting(value) {
  return axios
    .patch(url("/settings/custom_desired_value"), { value })
    .then(r => r.data.data.value)
    .catch(console.log);
}

export function updateTask(id, task) {
  return axios
    .patch(url(`/tasks/${id}`), task)
    .then(({ data: { data: t } }) => ({
      id: t.id,
      value: t.desired_value,
      time: moment(t.scheduled_at, "HH:mm")
    }))
    .catch(console.log);
}

export function deleteTask(id) {
  return axios.delete(url(`/tasks/${id}`));
}
