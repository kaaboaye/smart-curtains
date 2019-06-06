import * as React from "react";
import "./schedule.css";

export const Schedule = ({ tasks, onClick }) => {
  return (
    <div className="schedule--wrapper">
      {tasks.map(task => (
        <div key={task.id} onClick={() => onClick(task)} className="task">
          {task.time.format("LT")} - {task.value}%
        </div>
      ))}
    </div>
  );
};
