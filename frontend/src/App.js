import React from "react";
import moment from "moment";

import { Navigation } from "./containers/nav/Nav";

import "./App.css";
import {
  getCurrentState,
  createTask,
  getTasks,
  getLightReading,
  updateCurrentSetting,
  deleteTask,
  updateTask
} from "./api";
import { Slider } from "./containers/slider/Slider";
import { Schedule } from "./containers/schedule/schedule";
import { TaskEdit } from "./containers/task-edit/task-edit";

class App extends React.Component {
  state = {
    currentRoute: "HOME",
    currentSetting: 0,
    taskId: "null",
    // kinda dumb way to handle not sending the same value twice if user fe. clicks on the slider
    lastSentSetting: 0,
    tasks: [],
    light: null
  };

  // Up for you to implement
  // Sets the state to whatever you get from the backend
  componentDidMount() {
    getCurrentState().then(value => this.setState({ currentSetting: value }));
    this.updateLightReading();
    this.getTasks();
  }

  getTasks = () => {
    return getTasks().then(tasks =>
      this.setState({
        tasks: tasks.map(t => ({
          id: t.id,
          value: t.desired_value,
          time: moment(t.scheduled_at, "HH:mm")
        }))
      })
    );
  };

  updateLightReading = () => {
    getLightReading().then(light => {
      this.setState({ light });
      setTimeout(this.updateLightReading, 500);
    });
  };

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
          <div>
            <h2>{this.state.light || "unknown"} lm</h2>
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
          </div>
        )}
        {this.state.currentRoute === "SCHEDULE" && (
          <Schedule
            tasks={this.state.tasks}
            onClick={({ id: taskId }) =>
              this.setState({
                currentRoute: "TASK_EDIT",
                taskId
              })
            }
            onCreate={() => {
              createTask().then(({ id: taskId }) =>
                this.getTasks().then(() =>
                  this.setState({
                    currentRoute: "TASK_EDIT",
                    taskId
                  })
                )
              );
            }}
          />
        )}
        {this.state.currentRoute === "TASK_EDIT" && (
          <TaskEdit
            task={this.state.tasks.find(t => t.id === this.state.taskId)}
            onDelete={() =>
              deleteTask(this.state.taskId).then(() =>
                this.setState({
                  tasks: this.state.tasks.filter(
                    t => t.id !== this.state.taskId
                  ),
                  currentRoute: "SCHEDULE"
                })
              )
            }
            onSave={updatedTask => {
              updateTask(this.state.taskId, { task: updatedTask }).then(task =>
                this.setState({
                  currentRoute: "SCHEDULE",
                  tasks: this.state.tasks.map(t => {
                    if (t.id === this.state.taskId) {
                      return task;
                    }
                    return t;
                  })
                })
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
