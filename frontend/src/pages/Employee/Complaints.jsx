import React, { useState, useEffect } from "react";
import Table from "../../components/Table/Table";
import Filter from "../../components/Filter";
import Modal from "../../components/Modal";
import AddComplaint from "../../components/AddComplaint";

import dummyComplaints from "../../assets/data/dummyData.json";
import APIService from "../../api/Service";
import { equalsIgnoreCase } from "../../utils";

export default function Complaints({ complaintMode, setComplaintMode }) {
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
    status: ["All", "Resolved", "Registered", "Verified", "Unable to Resolve"],
  });

  const [currentFilters, setCurrentFilters] = useState({
    block: "All",
    floor: "All",
    status: "All",
  });

  const complaintTableHead = [
    "id",
    "block",
    "floor",
    "room",
    "complaint",
    "registeredTime",
    "updatedTime",
    "status",
  ];

  const updateComplaints = () => {
    let temp = complaints.filter(
      (complaint) =>
        (equalsIgnoreCase(currentFilters.block, complaint.block) ||
          equalsIgnoreCase(currentFilters.block, "All")) &&
        (equalsIgnoreCase(currentFilters.floor, complaint.floor + "") ||
          equalsIgnoreCase(currentFilters.floor, "All")) &&
        (equalsIgnoreCase(currentFilters.status, complaint.status) ||
          equalsIgnoreCase(currentFilters.status, "All"))
    );
    setCurrentComplaints(temp);
  };

  const renderHead = (item, index) => {
    let filteredItems = ["block", "floor", "status"];
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
    else if (item.status.toLowerCase() === "unable to resolve")
      labelType = "red";
    else if (item.status.toLowerCase() === "verified") labelType = "blue";
    else if (item.status.toLowerCase() === "registered") labelType = "yellow";

    return (
      <tr
        key={index}
        onClick={() => {
          setModalContents(item);
          setModalOpen(true);
        }}
      >
        <td>{item.id}</td>
        <td className="long-table-item">{item.block}</td>
        <td>{item.floor}</td>
        <td>{item.room}</td>
        <td className="long-table-item">{item.complaint}</td>
        <td>{item.registeredTime}</td>
        <td>{item.updatedTime}</td>
        <td align="center">
          <div className={`table-tag ${labelType}`}>{item.status}</div>
        </td>
      </tr>
    );
  };

  const getData = async () => {
    await APIService.PostData(
      {
        category: "institution",
        subtype: "electrician",
        email: "electrician@gmail.com",
      },
      "getComplaints/workers"
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

  useEffect(() => {
    window.innerWidth - window.innerHeight < 357
      ? setLimit(window.innerHeight / 100)
      : null;

    getData();
  }, []);

  useEffect(() => {
    getData();
  }, [complaintMode]);

  return (
    <>
      <Modal
        isOpen={modalOpen}
        setIsOpen={setModalOpen}
        modalContents={modalContents}
        title="Complaint Details"
      />
      {currentComplaints && (
        <Table
          limit={limit}
          title={complaintMode + " Complaints"}
          headData={complaintTableHead}
          renderHead={(item, index) => renderHead(item, index)}
          bodyData={currentComplaints}
          renderBody={(item, index) => renderBody(item, index)}
          addElement={
            <AddComplaint
              setComplaints={setComplaints}
              updateComplaints={updateComplaints}
              category="hostel"
            />
          }
        />
      )}
    </>
  );
}
