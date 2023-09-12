import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
//import 'dart:convert';
import 'dart:io';
// ignore_for_file: prefer_const_constructors


class MyCSVWidget extends StatefulWidget {
  @override
  _MyCSVWidgetState createState() => _MyCSVWidgetState();
}

class _MyCSVWidgetState extends State<MyCSVWidget> {
  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    readCSV();
  }

  Future<void> readCSV() async {
    final filePath = 'assets/attendance_list.csv'; // Adjust this path to your CSV file
    final File file = File(filePath);

    if (await file.exists()) {
      String csvString = await file.readAsString();
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);
      setState(() {
        csvData = csvTable;
      });
    } else {
      print("CSV file not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: csvData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(csvData[index].join(' | ')),
          );
        },
      ),
    );
  }
}