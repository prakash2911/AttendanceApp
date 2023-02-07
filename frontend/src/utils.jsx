export const equalsIgnoreCase = (str1, str2) => {
  return str1.toString().toUpperCase() === str2.toString().toUpperCase();
};

export function isObject(objValue) {
  return (
    objValue && typeof objValue === "object" && objValue.constructor === Object
  );
}

export const initialModalContents = {
  id: 1,
  block: "Block Name",
  floor: 1,
  room: 1,
  type: "Type Name",
  complaint: "Complaint Name",
  registeredTime: "1/1/1 01:00 AM",
  updatedTime: "1/1/1 01:00 AM",
  status: "Undefined",
};

export const initialEmployeeModalContents = {
  id: 1,
  block: "Block Name",
  floor: 1,
  room: 1,
  complaint: "Complaint Name",
  registeredTime: "1/1/1 01:00 AM",
  updatedTime: "1/1/1 01:00 AM",
  status: "Undefined",
};

export const initialFilters = {
  block: ["All", "Abdul Kalam Lecture Hall Complex", "RLHC", "CB"],
  floor: ["All", 1, 2, 3, 4],
  type: ["All", "Electrician", "Civil and Maintenance", "Education Aid"],
  status: ["All", "Resolved", "Registered", "Verified", "Unable to Resolve"],
};

export const defaultFilters = {
  block: "All",
  floor: "All",
  type: "All",
  status: "All",
};

export const initialEmployeeFilters = {
  block: ["All", "Abdul Kalam Lecture Hall Complex", "RLHC", "CB"],
  floor: ["All", 1, 2, 3, 4],
  status: ["All", "Resolved", "Registered", "Verified", "Unable to Resolve"],
};

export const employeeDefaultFilters = {
  block: "All",
  floor: "All",
  status: "All",
};

export const complaintTableHead = [
  "id",
  "block",
  "floor",
  "room",
  "type",
  "complaint",
  "registeredTime",
  "updatedTime",
  "status",
];

export const employeeComplaintTableHeade = [
  "id",
  "block",
  "floor",
  "room",
  "complaint",
  "registeredTime",
  "updatedTime",
  "status",
];

export const getLabelType = (status) => {
  if (equalsIgnoreCase(status, "resolved")) return "green";
  else if (equalsIgnoreCase(status, "unable to resolve")) return "red";
  else if (equalsIgnoreCase(status, "verified")) return "blue";
  else if (equalsIgnoreCase(status, "registered")) return "yellow";
};
