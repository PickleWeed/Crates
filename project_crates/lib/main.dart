//import packages, modules, tools
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/root.dart';
import 'package:flutter_application_1/screens/listing/Editinglist_page.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';

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
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('test'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Selectedlisting_page(
                  listingID: '-MX0Aha7l9tGdzi9gktJ', //listingID goes here
                )));
      },
    );
  }
}
