import React, { useState, useEffect } from "react";
import Table from "../../components/Table/Table";
import Filter from "../../components/Filter";
import Modal from "../../components/Modal";
import APIService from "../../api/Service";

import dummyComplaints from "../../assets/data/dummyData.json";

export default function InstitutionComplaints() {
  const [complaints, setComplaints] = useState();
  const [currentComplaints, setCurrentComplaints] = useState();
  const [limit, setLimit] = useState(8);

  const [modalOpen, setModalOpen] = useState(false);
  const [modalContents, setModalContents] = useState({
    id: 1,
    block: "Block Name",
    floor: 1,
    room: 1,
    type: "Type Name",
    complaint: "Complaint Name",
    registeredTime: "1/1/1 01:00 AM",
    updatedTime: "1/1/1 01:00 AM",
    status: "Undefined",
  });

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
    "complaint",
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

  const renderBody = (item, index) => {
    let labelType;
    if (item.status.toLowerCase() === "resolved") labelType = "green";
    else if (item.status.toLowerCase() === "reported") labelType = "red";
    else if (item.status.toLowerCase() === "verified") labelType = "blue";
    else if (item.status.toLowerCase() === "pending") labelType = "yellow";

    return (
      <tr
        key={index}
        onClick={() => {
          setModalContents(item);
          setModalOpen(true);
        }}
      >
        <td>{item.id}</td>
        <td>{item.block}</td>
        <td>{item.floor}</td>
        <td>{item.room}</td>
        <td>{item.type}</td>
        <td>{item.complaint}</td>
        <td>{item.registeredTime}</td>
        <td>{item.updatedTime}</td>
        <td align="center">
          <div className={`table-tag ${labelType}`}>{item.status}</div>
        </td>
      </tr>
    );
  };

  useEffect(() => {
    window.innerWidth - window.innerHeight < 357
      ? setLimit(window.innerHeight / 100 - 1)
      : null;

    const getData = async () => {
      await APIService.PostData(
        { category: "institution" },
        "getComplaints/admin"
      ).then((response) => {
        console.log(response);
        let data = response.complaint.map(function (item) {
          return {
            block: item.block,
            complaint: item.complaint,
            id: item.complaintid,
            type: item.complainttype,
            registeredTime: item.cts,
            floor: 1,
            room: item.roomno,
            status: item.status,
            updatedTime: item.uts,
          };
        });
        setComplaints(data);
        setCurrentComplaints(data);
      });
    };

    getData();
  }, []);

  return (
    <>
      <Modal
        isOpen={modalOpen}
        setIsOpen={setModalOpen}
        modalContents={modalContents}
        title="Complaint Details"
      />
      <div className="page-title">Institution Complaints</div>
      {currentComplaints && (
        <Table
          limit={limit}
          headData={complaintTableHead}
          renderHead={(item, index) => renderHead(item, index)}
          bodyData={currentComplaints}
          renderBody={(item, index) => renderBody(item, index)}
        />
      )}
    </>
  );
}
