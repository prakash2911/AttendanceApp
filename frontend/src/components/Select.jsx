import React, { useState, useEffect } from "react";

export default function Select({
  title,
  values,
  onChange,
  containerStyle,
  titleStyle,
}) {
  const [filters, setFilters] = useState(values);

  useEffect(() => {
    setFilters(values);
  }, [values]);

  return (
    <div className="filter-wrapper" style={containerStyle}>
      <div className="filter-title" style={titleStyle}>
        {title}
      </div>
      <div className="select">
        <select id="standard-select" onChange={(e) => onChange(e.target.value)}>
          {values.map((item, index) => (
            <option className="option" key={index} value={item}>
              {item}
            </option>
          ))}
        </select>
      </div>
      {/* <div className="select">
        <div className="select-text" onClick={() => setIsOpen(!isOpen)}>{value}</div>
        {isOpen && (
          <Dropdown
            values={values}
            setIsOpen={setIsOpen}
            onChange={({ key }) => {
              onChange(key);
              setValue(key);
            }}
            disposition="near"
          />
        )}
      </div> */}
    </div>
  );
}
