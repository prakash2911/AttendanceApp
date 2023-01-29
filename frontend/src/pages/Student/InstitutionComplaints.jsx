import React, { useState } from "react";
import Table from "../../components/Table/Table";

import dummyComplaints from "../../assets/data/dummyData.json";

export default function InstitutionComplaints() {
  const [complaints, setComplaints] = useState(dummyComplaints);

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
      <td>{item.block}</td>
      <td>{item.floor}</td>
      <td>{item.room}</td>
      <td>{item.registeredTime}</td>
      <td>{item.updatedTime}</td>
      <td>{item.status}</td>
    </tr>
  );

  return (
    <>
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
