import * as React from "react";
import ReactSlider from "react-rangeslider";
import "react-rangeslider/lib/index.css";
import "./slider-custom.css";

export class Slider extends React.Component {
  render() {
    return (
      <ReactSlider orientation="vertical" min={0} max={100} {...this.props} />
    );
  }
}
