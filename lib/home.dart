import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
//import 'package:camera/camera.dart';
//import 'package:opencv_4/opencv_4.dart';
//import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
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
               _showNewStudentDialog();
              //register_new_student();
            },
            child: Text("Register a new student")
          ),
          TextButton(
            onPressed: (){
              //remove_student();
              _showdeleteDialog();
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
  Future<void> _showdeleteDialog() async {
  String person = ''; // Initialize an empty string to store the student's name.

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete a Student'),
        content: TextField(
          onChanged: (value) {
            person = value; // Update the student's name as the user types.
          },
          decoration: InputDecoration(labelText: 'Student Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog.
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deletePerson(person);
              print(person);
              Navigator.of(context).pop(); // Close the dialog.
              },
            child: Text('Delete'),
            ),
          ],
        );
      },
      );
  }

  Future<void> _showNewStudentDialog() async {
  String studentName = ''; // Initialize an empty string to store the student's name.

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Register a New Student'),
        content: TextField(
          onChanged: (value) {
            studentName = value; // Update the student's name as the user types.
          },
          decoration: InputDecoration(labelText: 'Student Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog.
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              registerStudent(studentName);
              print(studentName);
              Navigator.of(context).pop(); // Close the dialog.
              },
            child: Text('Register'),
            ),
          ],
        );
      },
      );
  }

  registerStudent(String studentName) async {
  try {
    final response = await http.post(Uri.parse('http://127.0.0.1:5000/register-student/$studentName'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      //body: jsonEncode({'name': studentName}), // Send the student name in the request body.
    );
    if (response.statusCode == 200) {
      print('New student ($studentName) registered successfully');
    } else {
      print("1234");
      print('Failed to register new student: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  deletePerson(String person) async{
    try {
      final response = await http.post(Uri.parse('http://127.0.0.1:5000/delete_person/$person'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json', // Adjust the content type if needed
          },
      );
      if (response.statusCode == 200) {
        print('student deleted succesfully');
      } else {
        print('Failed to delete student: ${response.statusCode}');
      } 
    } catch(e){
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
      //body: MyCSVWidget(),
      //attendance_list.csv print karni hain edhar toh usse seedha parse karna and prine karna
    );
  }

  Widget known_faces_name_list() {
    return Container();
  }
  // Widget register_new_student() {
  //   return Container(
  //     child: registerStudent(),
  //   );
  // }
  // Widget remove_student() {
  //   return Container(
  //     child:deletePerson(),
  //   );
  // }
  Widget mark_attendance() {
    return Container(
      child: markAttendance(),
    );
  }
}