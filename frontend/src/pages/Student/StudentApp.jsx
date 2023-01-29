import React, { useState } from "react";
import InstitutionComplaints from "./InstitutionComplaints";
import HostelComplaints from "./HostelComplaints";
import Menubar from "../../components/Menubar";
import Table from "../../components/Table/Table";

import customerList from "../../assets/data/dummyData.json";

export default function StudentApp() {
  const [complaintState, setComplaintState] = useState("hostelComplaints");

  const customerTableHead = [
    "",
    "Block",
    "Floor",
    "Room",
    "RegisteredTime",
    "UpdatedTime",
    "Status",
  ];

  const renderHead = (item, index) => <th key={index}>{item}</th>;

  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{item.id}</td>
      <td>{item.roomID}</td>
      <td>{item.customerName}</td>
      <td>{item.startTime}</td>
      <td>{item.endTime}</td>
      <td>{item.startPerformance}</td>
      <td>{item.endPerformance}</td>
    </tr>
  );

  return (
    <>
      <Menubar />
      <Table
        limit="9"
        headData={customerTableHead}
        renderHead={(item, index) => renderHead(item, index)}
        bodyData={customerList}
        renderBody={(item, index) => renderBody(item, index)}
      />
    </>
  );
}
