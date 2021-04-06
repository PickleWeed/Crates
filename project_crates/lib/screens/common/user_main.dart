import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/activity/activity.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/listing/Newlisting_page.dart';
import 'package:flutter_application_1/screens/nearby/nearby.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';

class UserMain extends StatefulWidget{
  static String tag = 'users-page';
  @override
  _UserMainState createState() => new _UserMainState();
}
class _UserMainState extends State<UserMain>{
  int _currentIndex = 0;
  final List<Widget> _children =[
    Home(),
    Nearby(),
    Newlisting_page(),
    ActivityPage(),
    Profile()
  ];
  @override
  Widget build(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: primaryColor,
          selectedItemColor: Colors.orange[900],
          unselectedItemColor: Colors.white,
          selectedLabelStyle: textTheme.caption,
          unselectedLabelStyle: textTheme.caption,
          onTap: onTab,
          items:<BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text('Nearby'),
              icon: Icon(Icons.gps_fixed),
            ),
            BottomNavigationBarItem(
              title: Text('New listing'),
              icon: Icon(Icons.add_circle_outline),
            ),
            BottomNavigationBarItem(
              title: Text('Activity'),
              icon: Icon(Icons.notifications_none),
            ),
            BottomNavigationBarItem(
              title: Text('Profile'),
              icon: Icon(Icons.account_circle),
            ),
          ]

      ),
    );
  }
  void onTab(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}