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
      TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
);

const URL = "http://192.168.178.202:2002";
// const URL = "https://3645-42-106-184-128.ngrok.io";
