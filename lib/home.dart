import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Column(
        children: [
          Text("Attendance List"),
          Text("All Students List"),
          Text("Register a new student"),
          Text("Remove a student"),
          Text("Mark Attendance"),
          ],
      ),
    );
  }
}