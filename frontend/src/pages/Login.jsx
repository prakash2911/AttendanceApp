import React from "react";
import APIService from "../api/Service";

export default function Login() {
  return (
    <div
      className="button"
      onClick={async () => {
        await APIService.PostData(
          { category: "institution" },
          "getFilters"
        ).then((response) => {
          console.log(response);
        });
      }}
    >
      Click me
    </div>
  );
}
