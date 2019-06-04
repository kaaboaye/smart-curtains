import * as React from "react";
import "./schedule.css";

export const Schedule = ({ tasks, onClick }) => {
  return (
    <div className="schedule--wrapper">
      {tasks.map((task, i) => (
        <div
          key={`${task.time}_${i}`}
          onClick={() => onClick(i)}
          className="task"
        >
          {task.time.format("LT")} - {task.value}%
        </div>
      ))}
    </div>
  );
};
