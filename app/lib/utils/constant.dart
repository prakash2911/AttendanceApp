import 'package:flutter/material.dart';

// Repeated code for TextField
const kTextFiledInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
  ),
  labelText: " Email address",
  labelStyle:
      TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
);
const URL = "http://192.168.69.114:2002";

