import React, { useState, useEffect } from "react";
import Table from "../../components/Table/Table";
import Filter from "../../components/Filter";
import Modal from "../../components/Modal";
import AddComplaint from "../../components/AddComplaint";

import dummyComplaints from "../../assets/data/dummyData.json";
import APIService from "../../api/Service";
import {
  equalsIgnoreCase,
  initialModalContents,
  initialFilters,
  filterTypes,
  defaultFilters,
  complaintTableHead,
  getLabelType,
} from "../../utils";

export default function Complaints({ complaintMode, setComplaintMode }) {
  const [complaints, setComplaints] = useState(dummyComplaints);
  const [limit, setLimit] = useState(8);

  const [modalOpen, setModalOpen] = useState(false);
  const [modalContents, setModalContents] = useState(initialModalContents);

  // const [filters, setFilters] = useState(initialFilters);

  // const [currentFilters, setCurrentFilters] = useState(defaultFilters);

  // const updateComplaints = () => {
  //   let temp = complaints.filter(
  //     (complaint) =>
  //       (equalsIgnoreCase(currentFilters.block, complaint.block) ||
  //         equalsIgnoreCase(currentFilters.block, "All")) &&
  //       (equalsIgnoreCase(currentFilters.floor, complaint.floor + "") ||
  //         equalsIgnoreCase(currentFilters.floor, "All")) &&
  //       (equalsIgnoreCase(currentFilters.type, complaint.type) ||
  //         equalsIgnoreCase(currentFilters.type, "All")) &&
  //       (equalsIgnoreCase(currentFilters.status, complaint.status) ||
  //         equalsIgnoreCase(currentFilters.status, "All"))
  //   );
  //   // setCurrentComplaints(temp);
  // };

  const renderHead = (item, index) => {
    // if (filterTypes.includes(item))
    //   return (
    //     <th key={index}>
    //       <Filter
    //         title={item}
    //         values={filters[item]}
    //         onChange={(newFilterValue) => {
    //           setCurrentFilters((oldFilters) => {
    //             oldFilters[item] = newFilterValue;
    //             return oldFilters;
    //           });
    //           updateComplaints();
    //         }}
    //       />
    //     </th>
    //   );
    // else return <th key={index}>{item}</th>;
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
        <td>{item.type}</td>
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
      { category: complaintMode },
      "getComplaints/student"
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
      // setCurrentComplaints(data);
      // setCurrentFilters(defaultFilters);
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
      {complaints && (
        <Table
          limit={limit}
          title={complaintMode + " Complaints"}
          headData={complaintTableHead}
          renderHead={(item, index) => renderHead(item, index)}
          bodyData={complaints}
          renderBody={(item, index) => renderBody(item, index)}
          filters={initialFilters}
          defaultFilters={defaultFilters}
          filterTypes={filterTypes}
          addElement={
            <AddComplaint
              setComplaints={setComplaints}
              // updateComplaints={updateComplaints}
              category="hostel"
            />
          }
        />
      )}
    </>
  );
}
