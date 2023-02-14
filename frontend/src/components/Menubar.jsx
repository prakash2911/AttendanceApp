import React from "react";
import { useNavigate } from "react-router-dom";
import { FaRegUserCircle } from "react-icons/fa";

import APIService from "../api/Service";

export default function Menubar({ page, setPage, pages }) {
  const navigate = useNavigate();
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
          <div
            className="profile-logout-text"
            onClick={async () => {
              await APIService.PostData({}, "logout").then((response) => {
                console.log(response);
                sessionStorage.setItem("ck", "");
                navigate("/");
              });
            }}
          >
            Logout
          </div>
        </div>
      </div>
    </div>
  );
}
