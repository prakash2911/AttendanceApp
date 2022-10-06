import 'package:flutter/material.dart';

class adminTablist extends StatefulWidget {
  final List<String> ComplaintsPending;
  final List<String> ComplaintResolved;
  const adminTablist(
      {Key? key,
      required this.ComplaintsPending,
      required this.ComplaintResolved})
      : super(key: key);
  @override
  State<adminTablist> createState() => _adminTablistState();
}

class _adminTablistState extends State<adminTablist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
