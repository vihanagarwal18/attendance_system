import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
//import 'package:camera/camera.dart';
//import 'package:opencv_4/opencv_4.dart';
//import 'dart:typed_data';
import 'csv_file.dart';
//import 'camera_Capture.dart';
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
          TextButton(
            onPressed: () {
              view_attendance_list();
            },
            child: Text("Attendance List")
            ),
          TextButton(
            onPressed: (){
              known_faces_name_list();
            },
            child: Text("All Students List")
          ),
          TextButton(
            onPressed: (){
              register_new_student();
            },
            child: Text("Register a new student")
          ),
          TextButton(
            onPressed: (){
              remove_student();
            },
            child: Text("Remove a student")
          ),  
          TextButton(
            //onPressed: markAttendance,
            onPressed: (){
              mark_attendance();
            },
            child: Text("Mark Attendance")
          ),
        ],
      ),
    );
  }
  registerStudent () async {
  try {
    final response = await http.post(Uri.parse('http://127.0.0.1:5000/register-student'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json', // Adjust the content type if needed
        },
    );
    if (response.statusCode == 200) {
      print('new student registered succesfully');
    } else {
      print('Failed to register new student: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  }

  markAttendance() async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/mark-attendance'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json', // Adjust the content type if needed
      },
      // You can send an image as part of the request if required
      // body: <String, String>{
      //   'imageData': 'base64-encoded-image-data',
      // },
    );

    if (response.statusCode == 200) {
      print('Attendance marked successfully');
    } else {
      print('Failed to mark attendance: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  Widget view_attendance_list() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance List"),
      ),
      // child: Text("Attendance List"),
      body: MyCSVWidget(),
      //attendance_list.csv print karni hain edhar toh usse seedha parse karna and prine karna
    );
  }

  Widget known_faces_name_list() {
    return Container();
  }
  Widget register_new_student() {
    return Container(
      child: registerStudent(),
    );
  }
  Widget remove_student() {
    return Container();
  }
  Widget mark_attendance() {
    return Container(
      child: markAttendance(),
    );
  }
}