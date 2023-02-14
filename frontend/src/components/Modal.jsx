import React, { useState, useEffect } from "react";
import { AiOutlineCloseCircle } from "react-icons/ai";
import { equalsIgnoreCase } from "../utils";

export default function Modal({
  isOpen,
  setIsOpen,
  modalContents,
  customContent,
  children,
  title,
  type,
  onStatusChange,
}) {
  return (
    <div className={`modal-container ${isOpen ? "open" : "hidden"}`}>
      <div className={`modal ${isOpen ? "open" : "hidden"}`}>
        <div className="modal-header">
          {title && <div className="title">{title}</div>}
          <div className="modal-close-button" onClick={() => setIsOpen(false)}>
            <AiOutlineCloseCircle />
          </div>
        </div>
        {customContent ? (
          children
        ) : (
          <>
            <div className="modal-item">
              <div className="modal-item-title">ID</div>
              <div className="modal-item-desc">{modalContents.id}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Block</div>
              <div className="modal-item-desc">{modalContents.block}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Floor</div>
              <div className="modal-item-desc">{modalContents.floor}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Room</div>
              <div className="modal-item-desc">{modalContents.room}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Type</div>
              <div className="modal-item-desc">{modalContents.type}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Complaint</div>
              <div className="modal-item-desc">{modalContents.complaint}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Registered Time</div>
              <div className="modal-item-desc">
                {modalContents.registeredTime}
              </div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Updated Time</div>
              <div className="modal-item-desc">{modalContents.updatedTime}</div>
            </div>
            <div className="modal-item">
              <div className="modal-item-title">Status</div>
              <div className="modal-item-desc">{modalContents.status}</div>
            </div>
          </>
        )}
        {type && (
          <div className="modal-buttons-container">
            {type === "employee" && (
              <>
                {!equalsIgnoreCase(
                  modalContents.status,
                  "unable to resolve"
                ) && (
                  <div
                    className="button red"
                    onClick={() => {
                      onStatusChange(modalContents.id, "unable to resolve");
                      setIsOpen(false);
                    }}
                  >
                    Report
                  </div>
                )}
                {!equalsIgnoreCase(modalContents.status, "resolved") && (
                  <div
                    className="button"
                    onClick={() => {
                      onStatusChange(modalContents.id, "resolved");
                      setIsOpen(false);
                    }}
                  >
                    Resolve
                  </div>
                )}
              </>
            )}
            {type === "student" &&
              equalsIgnoreCase(modalContents.status, "resolved") && (
                <div
                  className="button"
                  onClick={() => {
                    onStatusChange(modalContents.id, "verified");
                    setIsOpen(false);
                  }}
                >
                  Verify
                </div>
              )}
          </div>
        )}
      </div>
    </div>
  );
}
