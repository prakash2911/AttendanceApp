import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import InstitutionComplaints from "./InstitutionComplaints";
import HostelComplaints from "./HostelComplaints";
import Menubar from "../../components/Menubar";

export default function AdminApp() {
  const [complaintMode, setComplaintMode] = useState("hostel");
  const navigate = useNavigate();

  return (
    <>
      <Menubar
        page={complaintMode}
        setPage={setComplaintMode}
        pages={["hostel", "institution"]}
      />
      <div className="main-app-wrapper">
        {complaintMode === "hostel" ? (
          <HostelComplaints />
        ) : (
          <InstitutionComplaints />
        )}
      </div>
    </>
  );
}
