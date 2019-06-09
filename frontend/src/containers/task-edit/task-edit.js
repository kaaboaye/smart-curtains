import * as React from "react";
import TimePicker from "rc-time-picker";
import "rc-time-picker/assets/index.css";
import { Slider } from "../slider/Slider";
import "./task-edit.css";

const format = "h:mm a";

export class TaskEdit extends React.Component {
  state = {
    selectedTime: this.props.task.time,
    value: this.props.task.value
  };

  render() {
    return (
      <div className="task-edit-wrapper">
        <TimePicker
          showSecond={false}
          defaultValue={this.props.task.time}
          className="task-edit task"
          onChange={value =>
            this.setState({
              selectedTime: value
            })
          }
          format={format}
          use12Hours
          inputReadOnly
        />
        <Slider
          value={this.state.value}
          onChange={value =>
            this.setState({
              value
            })
          }
        />

        <button onClick={this.props.onDelete} className="button button--delete">
          Delete
        </button>
        <button
          onClick={() =>
            this.props.onSave({
              scheduled_at: this.state.selectedTime.format("HH:mm:ss"),
              desired_value: this.state.value
            })
          }
          className="button button--save"
        >
          Save
        </button>
      </div>
    );
  }
}
