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

// const URL = "http://10.0.2.2:8090";
const URL = "http://192.168.109.197:2002";
// const URL = "http://127.0.0.1:8";
