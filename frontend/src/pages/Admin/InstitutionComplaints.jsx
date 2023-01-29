import React, { useState, useEffect } from "react";
import Table from "../../components/Table/Table";
import Filter from "../../components/Filter";

import dummyComplaints from "../../assets/data/dummyData.json";

export default function InstitutionComplaints() {
  const [complaints, setComplaints] = useState(dummyComplaints);
  const [currentComplaints, setCurrentComplaints] = useState(dummyComplaints);

  const [filters, setFilters] = useState({
    block: ["All", "Abdul Kalam Lecture Hall Complex", "RLHC", "CB"],
    floor: ["All", 1, 2, 3, 4],
    type: ["All", "Electrician", "Civil and Maintenance", "Education Aid"],
    status: ["All", "Resolved", "Pending", "Verified"],
  });

  const [currentFilters, setCurrentFilters] = useState({
    block: "All",
    floor: "All",
    type: "All",
    status: "All",
  });

  const complaintTableHead = [
    "no.",
    "block",
    "floor",
    "room",
    "type",
    "registeredTime",
    "updatedTime",
    "status",
  ];

  const updateComplaints = () => {
    let temp = complaints.filter(
      (complaint) =>
        (currentFilters.block === "All" ||
          currentFilters.block === complaint.block) &&
        (currentFilters.floor === "All" ||
          currentFilters.floor === complaint.floor) &&
        (currentFilters.type === "All" ||
          currentFilters.type === complaint.type) &&
        (currentFilters.status === "All" ||
          currentFilters.status === complaint.status)
    );
    setCurrentComplaints(temp);
  };

  const renderHead = (item, index) => {
    let filteredItems = ["block", "floor", "type", "status"];
    if (filteredItems.includes(item))
      return (
        <th key={index}>
          <Filter
            title={item}
            values={filters[item]}
            onChange={(newFilterValue) => {
              setCurrentFilters((oldFilters) => {
                oldFilters[item] = newFilterValue;
                return oldFilters;
              });
              updateComplaints();
            }}
          />
        </th>
      );
    else return <th key={index}>{item}</th>;
  };

  const renderBody = (item, index) => (
    <tr key={index}>
      <td>{item.id}</td>
      <td>{item.block}</td>
      <td>{item.floor}</td>
      <td>{item.room}</td>
      <td>{item.type}</td>
      <td>{item.registeredTime}</td>
      <td>{item.updatedTime}</td>
      <td>{item.status}</td>
    </tr>
  );

  return (
    <>
      <div className="page-title">Institution Complaints</div>
      <Table
        limit="9"
        headData={complaintTableHead}
        renderHead={(item, index) => renderHead(item, index)}
        bodyData={currentComplaints}
        renderBody={(item, index) => renderBody(item, index)}
      />
    </>
  );
}
