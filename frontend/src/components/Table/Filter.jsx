import React, { useState, useEffect } from "react";
import { FaFilter } from "react-icons/fa";
import Dropdown from "../Dropdown/Dropdown";

export default function Filter({ filters, onChange }) {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <div className="filter-icon-wrapper">
      <div className="filter-icon" onClick={() => setIsOpen(!isOpen)}>
        <FaFilter size={22} />
      </div>
      {isOpen && (
        <Dropdown values={filters} onChange={onChange} setIsOpen={setIsOpen} />
      )}
    </div>
  );
}
