import React from "react";
import moment from "moment";
import axios from "axios";

import { Navigation } from "./containers/nav/Nav";

import "./App.css";
import { Slider } from "./containers/slider/Slider";
import { Schedule } from "./containers/schedule/schedule";
import { TaskEdit } from "./containers/task-edit/task-edit";

function getCurrentState() {
  return axios
    .get("/api/settings/custom_desired_value")
    .then(r => r.data.data.value)
    .catch(console.log);
}

function getTasks() {
  return axios
    .get("/api/tasks")
    .then(r => r.data.data)
    .catch(console.log);
}

function updateCurrentSetting(value) {
  return axios
    .patch("/api/settings/custom_desired_value", { value })
    .then(r => r.data.data.value)
    .catch(console.log);
}

class App extends React.Component {
  state = {
    currentRoute: "HOME",
    currentSetting: 0,
    taskIndex: 0,
    // kinda dumb way to handle not sending the same value twice if user fe. clicks on the slider
    lastSentSetting: 0,
    tasks: []
  };

  // Up for you to implement
  // Sets the state to whatever you get from the backend
  componentDidMount() {
    getCurrentState().then(value => this.setState({ currentSetting: value }));

    getTasks().then(tasks =>
      this.setState({
        tasks: tasks.map(t => ({
          id: t.id,
          value: t.desired_value,
          time: moment(t.scheduled_at, "HH:mm")
        }))
      })
    );
  }

  sendUpdatedCurrentSetting = () => {
    if (this.state.lastSentSetting !== this.state.currentSetting) {
      updateCurrentSetting(this.state.currentSetting).then(setting =>
        this.setState({
          currentSetting: setting,
          lastSentSetting: setting
        })
      );
    }
  };

  render() {
    return (
      <div id="app">
        {this.state.currentRoute === "HOME" && (
          <Slider
            value={this.state.currentSetting}
            onChange={value =>
              this.setState({
                currentSetting: value
              })
            }
            onChangeComplete={() => {
              this.sendUpdatedCurrentSetting();
            }}
          />
        )}
        {this.state.currentRoute === "SCHEDULE" && (
          <Schedule
            tasks={this.state.tasks}
            onClick={index =>
              this.setState({
                currentRoute: "TASK_EDIT",
                taskIndex: index
              })
            }
          />
        )}
        {this.state.currentRoute === "TASK_EDIT" && (
          <TaskEdit
            task={this.state.tasks[this.state.taskIndex]}
            onDelete={() => {
              this.setState({
                tasks: this.state.tasks.filter(
                  (_, taskIndex) => taskIndex !== this.state.taskIndex
                ),
                currentRoute: "SCHEDULE"
              });
            }}
            onSave={newTaskValues => {
              this.setState(
                {
                  currentRoute: "SCHEDULE",
                  tasks: this.state.tasks.map((task, taskIndex) => {
                    if (taskIndex === this.state.taskIndex) {
                      return newTaskValues;
                    }
                    return task;
                  })
                },
                () => this.sendUpdatedSchedule()
              );
            }}
          />
        )}
        <Navigation
          min={0}
          max={100}
          value={10}
          onSunnyClick={() =>
            this.setState({
              currentRoute: "HOME"
            })
          }
          onClockClick={() =>
            this.setState({
              currentRoute: "SCHEDULE"
            })
          }
        />
      </div>
    );
  }
}

export default App;
