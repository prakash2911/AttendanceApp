import React from "react";

export default function Filter({ title, values, onChange }) {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <div className="filter-title">{title}</div>
      <div class="select">
        <select id="standard-select" onChange={(e) => onChange(e.target.value)}>
          {values.map((item, index) => (
            <option key={index} value={item}>
              {item}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
}
