//import packages, modules, tools
import 'package:flutter/material.dart';
import 'login.dart';
import 'app_theme.dart';
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
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.android,
      ),
      home: LoginPage(),
    );
  }
}
