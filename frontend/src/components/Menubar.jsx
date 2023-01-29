import React from "react";
import { FaRegUserCircle } from "react-icons/fa";

export default function Menubar({ page, setPage, pages }) {
  return (
    <div className="menu-bar">
      <div className="logo">MIT</div>
      <div className="right-items">
        {pages.map((item, index) => (
          <div
            className="menu-bar-button"
            key={index}
            onClick={() => setPage(item)}
          >
            {item}
          </div>
        ))}
        <div className="profile">
          <FaRegUserCircle size={24} />
          <div className="profile-logout-text">Logout</div>
        </div>
      </div>
    </div>
  );
}
