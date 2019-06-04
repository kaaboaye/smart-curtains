import * as React from "react";
import "./nav.css";
import schedule from "./images/schedule.svg";
import sunny from "./images/sunny.svg";

export const Navigation = ({ onSunnyClick, onClockClick }) => (
  <div className="nav">
    <span onClick={onSunnyClick}>
      <button className="nav__button">
        <img src={schedule} alt="schedule" />
        <span className="nav__link">Current setting</span>
      </button>
    </span>
    <span onClick={onClockClick}>
      <button className="nav__button">
        <img src={sunny} alt="sunny" />
        <span className="nav__link">Schedule</span>
      </button>
    </span>
  </div>
);
