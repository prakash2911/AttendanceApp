import React, { useState, useEffect } from "react";
import { BsPlusLg } from "react-icons/bs";
import Modal from "./Modal";
import Filter from "./Filter";
import Button from "./Button";

const headers = ["block", "floor", "room", "type", "category"];

const dropdownValues = {
  block: ["Abdul Kalam Lecture Hall Complex", "RLHC", "CB"],
  floor: [1, 2, 3, 4],
  room: [101, 102, 103, 104, 105, 106],
  type: ["Electrician", "Civil and Maintenance", "Education Aid"],
  category: [
    "Benches Broken",
    "Benches Nail Came Out",
    "Board Broken",
    "Projector Broken",
  ],
};

export default function AddComplaint(props) {
  const [isOpen, setIsOpen] = useState(false);

  //props.category is hostel/institution

  const [complaint, setComplaint] = useState({
    block: "Abdul Kalam Lecture Hall Complex",
    floor: 1,
    room: 101,
    type: "Electrician",
    category: "Benches Broken",
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
              <Filter
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
                props.updateComplaints();
              }}
            />
          </div>
        </div>
      </Modal>
      <div
        className="add-complaint-plus-container"
        onClick={() => setIsOpen(true)}
      >
        <div className="add-complaint-plus">
          <BsPlusLg />
        </div>
      </div>
    </>
  );
}
