import React, { useState, useEffect } from "react";
import { BsPlusLg } from "react-icons/bs";
import Modal from "./Modal";
import Select from "./Select";
import Button from "./Button";

import APIService from "../api/Service";
import { isObject } from "../utils";

export default function AddComplaint(props) {
  const [isOpen, setIsOpen] = useState(false);
  const [blockDetails, setBlockDetails] = useState();
  const [complaintDetails, setComplaintDetails] = useState();

  const [blockNames, setBlockNames] = useState();
  const [complaintTypes, setComplaintTypes] = useState();

  const [complaint, setComplaint] = useState({
    block: "Abdul Kalam Lecture Hall",
    floor: 1,
    room: 101,
    type: "Electrician",
    complaint: "Benches Broken",
  });

  const asd = async () => {
    await APIService.PostData(
      { category: props.complaintMode },
      "getBlocksData"
    ).then((response) => {
      console.log(response);
      setBlockDetails(response);
      if (isObject(response)) {
        let block_names = Object.keys(response);
        setBlockNames(block_names);
        setComplaint((old) => ({
          ...old,
          block: block_names[0],
          floor: response[block_names[0]].floors[0],
          room: response[block_names[0]].rooms[0][0],
        }));
      }
    });
    await APIService.PostData(
      { category: props.complaintMode },
      "getcomplaintTy"
    ).then((response) => {
      console.log(response);
      setComplaintDetails(response);
      if (isObject(response)) {
        let complaint_types = Object.keys(response);
        setComplaintTypes(complaint_types);
        setComplaint((old) => ({
          ...old,
          type: complaint_types[0],
          complaint: response[complaint_types[0]][0],
        }));
      }
    });
  };

  const initDropdownValues = () => {
    setBlockDetails(props.blockDetails);
    if (isObject(props.blockDetails)) {
      let block_names = Object.keys(props.blockDetails);
      setBlockNames(block_names);
      setComplaint((old) => ({
        ...old,
        block: block_names[0],
        floor: props.blockDetails[block_names[0]].floors[0],
        room: props.blockDetails[block_names[0]].rooms[0][0],
      }));
    }
    setComplaintDetails(props.complaintDetails);
    if (isObject(props.complaintDetails)) {
      let complaint_types = Object.keys(props.complaintDetails);
      setComplaintTypes(complaint_types);
      setComplaint((old) => ({
        ...old,
        type: complaint_types[0],
        complaint: props.complaintDetails[complaint_types[0]][0],
      }));
    }
  };

  const logshit = async () => {
    console.log(blockNames);
    console.log(complaintTypes);
  };

  useEffect(() => {
    initDropdownValues();
  }, [props.blockDetails, props.complaintDetails]);

  const resetBlockInfo = (value) => {
    setComplaint((old) => {
      let temp = {
        ...old,
        floor: blockDetails[value].floors[0],
        room: blockDetails[value].rooms[0][0],
      };
      // console.log(temp);
      return temp;
    });
  };

  const resetRoomInfo = (value) => {
    setComplaint((old) => {
      let temp = {
        ...old,
        room: blockDetails[complaint.block].rooms[value - 1][0],
      };
      // console.log(temp);
      return temp;
    });
    // console.log(complaint);
  };

  const resetComplaintTypeInfo = (value) => {
    setComplaint((old) => {
      let temp = {
        ...old,
        complaint: complaintDetails[value][0],
      };
      // console.log(temp);
      return temp;
    });
  };

  return (
    <>
      <Modal
        customContent={true}
        isOpen={isOpen}
        setIsOpen={setIsOpen}
        title="Add Complaints"
      >
        <div className="add-complaint-input-wrapper">
          {blockDetails && complaintDetails && (
            <>
              <Select
                title="Block"
                value={complaint.block}
                values={blockNames}
                onChange={(value) => {
                  setComplaint((old) => ({ ...old, block: value }));
                  resetBlockInfo(value);
                }}
              />
              <Select
                title="Floor"
                value={complaint.floor}
                values={blockDetails[complaint.block].floors}
                onChange={(value) => {
                  setComplaint((old) => ({ ...old, floor: value }));
                  resetRoomInfo(value);
                }}
              />
              <Select
                title="Room"
                value={complaint.room}
                values={
                  blockDetails[complaint.block].rooms[complaint.floor - 1]
                }
                onChange={(value) => {
                  setComplaint((old) => {
                    let temp = { ...old, room: value };
                    // console.log(temp);
                    return temp;
                  });
                }}
              />
              <Select
                title="Type"
                value={complaint.type}
                values={complaintTypes}
                onChange={(value) => {
                  setComplaint((old) => {
                    let temp = { ...old, type: value };
                    // console.log(temp);
                    return temp;
                  });
                  resetComplaintTypeInfo(value);
                }}
              />
              <Select
                title="Complaint"
                value={complaint.complaint}
                values={complaintDetails[complaint.type]}
                onChange={(value) => {
                  setComplaint((old) => {
                    let temp = { ...old, complaint: value };
                    // console.log(temp);
                    return temp;
                  });
                }}
              />
            </>
          )}
          <div
            style={{
              display: "flex",
              justifyContent: "flex-end",
              marginTop: "1rem",
            }}
          >
            <Button
              title="Add"
              onClick={() => {
                props.setComplaints((old) => [
                  ...old,
                  {
                    ...complaint,
                    id: old.length + 1,
                    registeredTime: "1/1/1 01:00 AM",
                    updatedTime: "1/1/1 01:00 AM",
                    status: "Pending",
                  },
                ]);
                setIsOpen(false);
                const sendComplaint = async () => {
                  await APIService.PostData(
                    {
                      utype: sessionStorage.getItem("cookie").utype,
                      email: sessionStorage.getItem("cookie").email,
                      Block: complaint.block,
                      Floor: complaint.floor,
                      RoomNo: complaint.room,
                      complainttype: complaint.type,
                      Complaint: complaint.complaint,
                    },
                    props.cateogry === "institution"
                      ? "college_registercomplaint"
                      : "hostel_registercomplaint"
                  ).then((response) => {
                    console.log(response);
                  });
                };
                sendComplaint();
              }}
            />
          </div>
        </div>
      </Modal>
      <div
        className="add-complaint-plus-container"
        // className="table__pagination-item active"
        onClick={() => setIsOpen(true)}
      >
        <div className="add-complaint-plus">
          <BsPlusLg />
        </div>
      </div>
    </>
  );
}
