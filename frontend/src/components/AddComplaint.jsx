import React, { useState, useEffect } from "react";
import { BsPlusLg } from "react-icons/bs";
import Modal from "./Modal";
import Select from "./Select";
import Button from "./Button";

import APIService from "../api/Service";

const headers = ["block", "floor", "room", "type", "complaint"];

const dropdownValues = {
  block: ["Abdul Kalam Lecture Hall Complex", "RLHC", "CB"],
  floor: [1, 2, 3, 4],
  room: [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120],
  type: ["Electrician", "Civil and Maintenance", "Education Aid"],
  complaint: [
    "Benches Broken",
    "Benches Nail Came Out",
    "Board Broken",
    "Projector Broken",
  ],
};

export default function AddComplaint(props) {
  const [isOpen, setIsOpen] = useState(false);

  //props.complaint is hostel/institution

  const [complaint, setComplaint] = useState({
    block: "Abdul Kalam Lecture Hall Complex",
    floor: 1,
    room: 101,
    type: "Electrician",
    complaint: "Benches Broken",
  });

  return (
    <>
      <Modal
        customContent={true}
        isOpen={isOpen}
        setIsOpen={setIsOpen}
        title="Add Complaints"
      >
        <div className="add-complaint-input-wrapper">
          {headers.map((item, index) => (
            <div key={index}>
              <Select
                title={item}
                values={dropdownValues[item]}
                onChange={(value) =>
                  setComplaint((old) => {
                    old[item] = value;
                    return old;
                  })
                }
                containerStyle={{
                  justifyContent: "space-between",
                  flexDirection: "row",
                  marginBottom: "2vh",
                }}
                titleStyle={{ fontWeight: 500 }}
              />
            </div>
          ))}
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
                      utype: "Student",
                      email: "vinay@gmail.com",
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
