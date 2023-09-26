import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';
//import 'package:camera/camera.dart';
import 'package:restart_app/restart_app.dart';
import 'package:opencv_4/opencv_4.dart';
//import 'dart:typed_data';
//import 'package:fluttertoast/fluttertoast.dart';
// ignore_for_file: prefer_const_constructors

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {

  List<List<dynamic>> attendance_data=[];
  List<List<dynamic>> known_face_data=[];

  void _loadCSV_attendance() async{
    final _rawdata1=await rootBundle.loadString("assets/attendance_list.csv");
    List<List<dynamic>> _listdata1=const CsvToListConverter().convert(_rawdata1);
    setState(() {
      attendance_data= _listdata1;
    });
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => view_attendance_list()),
    // );
  }

  Future <void> _loadCSV_known() async{
     final _rawdata2=await rootBundle.loadString("assets/known_faces.csv");
     List<List<dynamic>> _listdata2=CsvToListConverter().convert(_rawdata2);
     known_face_data=_listdata2;
    // setState(() async {
    //   //final _rawdata2=await rootBundle.loadString("assets/known_faces.csv");
    //   //List<List<dynamic>> _listdata2=CsvToListConverter().convert(_rawdata2);
    //   known_face_data= _listdata2;
    //   print(_listdata2);
    //   //print(known_face_data);
    // });
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => known_faces_name_list()),
    // );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10.0)),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                //foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                //disabledForegroundColor: Colors.grey,
                shadowColor: Colors.yellow,
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                _loadCSV_attendance();
                print(5);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => view_attendance_list()),
                );
                //view_attendance_list();
              },
              child: Text("Attendance List",
                  style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2.0,
                  fontFamily: 'OpenSans',
                  ),
                ),
              ),
            Padding(padding: EdgeInsets.all(15.0)),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                //foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                //disabledForegroundColor: Colors.grey,
                shadowColor: Colors.yellow,
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async{
                print("Button pressed");
                await _loadCSV_known();
                print("Button pressed successfully");
                //known_faces_name_list();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => known_faces_name_list()),
                );
                print(6);
              },
              child: Text("All Students List",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2.0,
                  fontFamily: 'OpenSans',
                  ),
              )
            ),
            Padding(padding: EdgeInsets.all(15.0)),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                //foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                //disabledForegroundColor: Colors.grey,
                shadowColor: Colors.yellow,
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: (){
                 //_loadCSV_known();
                 _showNewStudentDialog();
                 Restart.restartApp();
              },
              child: Text("Register a new student",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2.0,
                  fontFamily: 'OpenSans',
                  ),
              )
            ),
            Padding(padding: EdgeInsets.all(15.0)),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                //foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                //disabledForegroundColor: Colors.grey,
                shadowColor: Colors.yellow,
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: (){
                _showdeleteDialog();
                Restart.restartApp();
              },
              child: Text("Remove a student",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2.0,
                  fontFamily: 'OpenSans',
                  ),
              )
            ),
            Padding(padding: EdgeInsets.all(15.0)),  
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                //foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                //disabledForegroundColor: Colors.grey,
                shadowColor: Colors.yellow,
                elevation: 15.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: (){
                mark_attendance();
              },
              child: Text("Mark Attendance",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 2.0,
                  fontFamily: 'OpenSans',
                  ),
              )
            ),
          ],
        ),
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
              Navigator.of(context).pop();// Close the dialog.
              //_loadCSV_known();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deletePerson(person);
              _loadCSV_known();
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
              //_loadCSV_known();
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
    //_loadCSV_known();
    if (response.statusCode == 200) {
      print('New student ($studentName) registered successfully');
    } else {
      print("1234");
      print('Failed to register new student: ${response.statusCode}');
      _loadCSV_known();
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
      //_loadCSV_known();
      if (response.statusCode == 200) {
        print('student deleted succesfully');
       // _loadCSV_known();
      } else {
        print('Failed to delete student: ${response.statusCode}');
        //_loadCSV_known();
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
    //_loadCSV_attendance();

    if (response.statusCode == 200) {
      print('Attendance marked successfully');
    } else {
      print('Failed to mark attendance: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  Widget view_attendance_list(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance  List"),
      ),
      body: ListView.builder(
        itemCount: attendance_data.length,
        itemBuilder: (_,index){
          return Card(
            margin: const EdgeInsets.all(3),
            color: (index==0)?Colors.blue:Colors.red,
            child: ListTile(
              leading: Text(attendance_data[index][0].toString()),
              title: Text(attendance_data[index][1].toString()),
              trailing: Text(attendance_data[index][2].toString()),
            ),
          );
        }
      ),
    );
  }

  Widget known_faces_name_list() {
    _loadCSV_known();
    return Scaffold(
      appBar: AppBar(
        title: Text("Known faces List"),
      ),
      body: ListView.builder(
          itemCount: known_face_data.length,
          itemBuilder: (_,index){
            return Card(
              margin: const EdgeInsets.all(3),
              color: Colors.red,
              child: ListTile(
                leading: Text(known_face_data[index][0].toString()),
              ),
            );
          }
      ),
    );
  }
  Widget mark_attendance() {
    return Container(
      child: markAttendance(),
    );
  }
}