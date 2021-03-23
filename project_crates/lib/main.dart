//import packages, modules, tools
import 'package:flutter/material.dart';
import 'DatabaseTesting/CloudStorageTest.dart';
import 'DatabaseTesting/CreateListingTest.dart';
import 'DatabaseTesting/RetrieveListingTest.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
} //entry point

//StatelessWidget: does not have state. does not change with interaction with the program
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        platform: TargetPlatform.android,
      ),
      home: RetrieveListingTest(),
    );
  }
}
