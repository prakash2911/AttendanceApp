import React, { useState } from "react";
import Complaints from "./Complaints";
import Menubar from "../../components/Menubar";

export default function EmployeeApp() {
  const [complaintMode, setComplaintMode] = useState("hostel");

  return (
    <>
      <Menubar
        page={complaintMode}
        setPage={setComplaintMode}
        pages={["hostel", "institution"]}
      />
      <div className="main-app-wrapper">
        <Complaints
          complaintMode={complaintMode}
          setComplaintMode={setComplaintMode}
        />
      </div>
    </>
  );
}
