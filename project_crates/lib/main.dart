//import packages, modules, tools
import 'package:flutter/material.dart';
import 'login.dart';
import 'screens/wrapper.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'login.dart';
import 'screens/nearby/nearby.dart';
import 'screens/nearby/nearbyFilter.dart';


void main() {
  runApp(MyApp());
} //entry point


//StatelessWidget: does not have state. does not change with interaction with the program
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder> {
        '/nearby': (BuildContext context) => new Nearby(),
        '/login' : (BuildContext context) => new LoginPage(),
        //'/nearby/filter' : (BuildContext context) => new NearbyFilter(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        platform: TargetPlatform.android,
      ),
      home: Wrapper(),
    );
  }
}
