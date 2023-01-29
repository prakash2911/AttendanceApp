import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import InstitutionComplaints from "./InstitutionComplaints";
import HostelComplaints from "./HostelComplaints";
import Menubar from "../../components/Menubar";
import Table from "../../components/Table/Table";

import dummyComplaints from "../../assets/data/dummyData.json";

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
      {complaintMode === "hostel" ? <HostelComplaints /> : <InstitutionComplaints />}
    </>
  );
}
