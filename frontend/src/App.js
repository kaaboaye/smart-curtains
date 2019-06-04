import React from "react";
import moment from "moment";

import { Navigation } from "./containers/nav/Nav";

import "./App.css";
import { Slider } from "./containers/slider/Slider";
import { Schedule } from "./containers/schedule/schedule";
import { TaskEdit } from "./containers/task-edit/task-edit";

class App extends React.Component {
  state = {
    currentRoute: "HOME",
    currentSetting: 0,
    taskIndex: 0,
    // kinda dumb way to handle not sending the same value twice if user fe. clicks on the slider
    lastSentSetting: 0,
    tasks: [
      {
        time: moment("04:04", "HH:mm"),
        value: 0
      },
      {
        time: moment("05:05", "HH:mm"),
        value: 0
      },
      {
        time: moment("06:06", "HH:mm"),
        value: 0
      },
      {
        time: moment("07:07", "HH:mm"),
        value: 0
      },
      {
        time: moment("08:08", "HH:mm"),
        value: 0
      }
    ]
  };

  // Up for you to implement
  // Sets the state to whatever you get from the backend
  // componentDidMount() {
  //   fetch("backend/get_state")
  //     .then(res => res.json)
  //     .then(res => {
  //       // look up the response if needed
  //       console.log(res)
  //       this.setState({
  //         tasks: res.tasks
  //       });
  //     });
  // }

  sendUpdatedSchedule = () => {
    console.log(
      "here should go the request with",
      this.state.tasks.map(task => ({
        time: task.time.format("HH:mm"),
        value: task.value
      }))
    );
  };

  sendUpdatedCurrentSetting = () => {
    if (this.state.lastSentSetting !== this.state.currentSetting) {
      this.setState(
        {
          lastSentSetting: this.state.currentSetting
        },
        () =>
          console.log(
            "here should go the request with",
            this.state.currentSetting
          )
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
            onDelete={
              (() => {
                this.setState({
                  tasks: this.state.tasks.filter(
                    ({}, taskIndex) => taskIndex !== this.state.taskIndex
                  ),
                  currentRoute: "SCHEDULE"
                });
              },
              () => this.sendUpdatedSchedule())
            }
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
