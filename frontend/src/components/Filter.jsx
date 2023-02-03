import React from "react";

export default function Filter({
  title,
  values,
  onChange,
  containerStyle,
  titleStyle,
}) {
  return (
    <div className="filter-wrapper" style={containerStyle}>
      <div className="filter-title" style={titleStyle}>
        {title}
      </div>
      <div className="select">
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
