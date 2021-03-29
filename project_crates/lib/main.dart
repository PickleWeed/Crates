//import packages, modules, tools
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/root.dart';
import 'package:flutter_application_1/screens/common/admin_main.dart';
import 'package:flutter_application_1/screens/common/user_main.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/home/homeListView.dart';
import 'package:flutter_application_1/screens/home/homeV2.dart';
import 'package:provider/provider.dart';
import 'screens/authenticate/sign_in.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => HomeListViewModel(),
      child:MyApp(),
    ),
  );
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
      home:RootPage(),

    );
  }
}
