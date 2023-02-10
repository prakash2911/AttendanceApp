import React, { useState, useEffect } from "react";
import Table from "../../components/Table/Table";
import Modal from "../../components/Modal";
import AddComplaint from "../../components/AddComplaint";

import APIService from "../../api/Service";
import {
  initialModalContents,
  employeeDefaultFilters,
  complaintTableHead,
  getLabelType,
  equalsIgnoreCase,
} from "../../utils";

export default function Complaints({ complaintMode, setComplaintMode }) {
  const [complaints, setComplaints] = useState();
  const [limit, setLimit] = useState(8);

  const [modalOpen, setModalOpen] = useState(false);
  const [modalContents, setModalContents] = useState(initialModalContents);
  const [blockDetails, setBlockDetails] = useState();

  const [filters, setFilters] = useState({
    block: [],
    floor: [],
    status: ["Resolved", "Registered", "Verified", "Unable to resolve"],
  });

  const renderHead = (item, index) => {
    if (equalsIgnoreCase(item, "type")) return null;
    return <th key={index}>{item}</th>;
  };

  const renderBody = (item, index) => {
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
          <div className={`table-tag ${getLabelType(item.status)}`}>
            {item.status}
          </div>
        </td>
      </tr>
    );
  };

  const getData = async () => {
    await APIService.PostData(
      {
        category: complaintMode,
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
    });
  };

  const getDropdownValues = async () => {
    let newFilters = {
      block: ["All"],
      floor: [],
      status: [
        "All",
        "Resolved",
        "Registered",
        "Verified",
        "Unable to resolve",
      ],
    };
    await APIService.PostData(
      { category: complaintMode },
      "getBlocksData"
    ).then((response) => {
      console.log(response);
      setBlockDetails(response);
      newFilters.block = ["All", ...Object.keys(response)];
      for (let block_name of Object.keys(response))
        newFilters.floor.push(["All", ...response[block_name].floors]);
    });
    console.log(newFilters);
    setFilters(newFilters);
  };

  useEffect(() => {
    window.innerWidth - window.innerHeight < 357
      ? setLimit(window.innerHeight / 100)
      : null;
  }, []);

  useEffect(() => {
    getData();
    getDropdownValues();
  }, [complaintMode]);

  return (
    <>
      <Modal
        isOpen={modalOpen}
        setIsOpen={setModalOpen}
        modalContents={modalContents}
        title="Complaint Details"
        type="employee"
        onStatusChange={async (id, status) => {
          await APIService.PostData(
            {
              complaintid: id,
              status: status,
            },
            "college_change_complaint_status"
          ).then((response) => {
            console.log(response);
          });
        }}
      />
      {complaints && (
        <Table
          limit={limit}
          title={complaintMode + " Complaints"}
          headData={complaintTableHead}
          renderHead={(item, index) => renderHead(item, index)}
          bodyData={complaints}
          renderBody={(item, index) => renderBody(item, index)}
          filters={filters}
          defaultFilters={employeeDefaultFilters}
        />
      )}
    </>
  );
}
