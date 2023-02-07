import React, { useState } from "react";
import { TbLock, TbEye } from "react-icons/tb";

export default function TextInput(props) {
  const [visible, setVisible] = useState(false);
  return (
    <div className="text-input-wrapper">
      {props.icon && <div className="icon-wrapper">{props.icon}</div>}
      <input
        type={props.type === "password" && !visible ? "password" : "text"}
        className="text-input"
        placeholder={props.placeholder}
        onChange={(e) => props.onChange(e.target.value)}
      />
      {props.type === "password" && (
        <div className="text-input-eye" onClick={() => setVisible(!visible)}>
          <TbEye />
        </div>
      )}
    </div>
  );
}
