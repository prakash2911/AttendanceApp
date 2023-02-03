import React from "react";
import { Route, BrowserRouter, Routes } from "react-router-dom";
import Login from "./Login";
import SignUp from "./SignUp";
import StudentApp from "./Student/StudentApp";
import AdminApp from "./Admin/AdminApp";
import EmployeeApp from "./Employee/EmployeeApp";

export default function RouteConfig() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/student" element={<StudentApp />} />
        <Route path="/admin" element={<AdminApp />} />
        <Route path="/employee" element={<EmployeeApp />} />
      </Routes>
    </BrowserRouter>
  );
}
