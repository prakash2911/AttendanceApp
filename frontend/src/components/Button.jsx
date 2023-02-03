import React from "react";

export default function Button(props) {
  return (
    <div
      className={`button ${props.invert ? "invert" : ""}`}
      onClick={props.onClick}
      style={props.style}
    >
      {props.title}
    </div>
  );
}
