import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectcrates/pages/chatpage.dart';
import 'package:projectcrates/pages/notificationpage.dart';
import 'package:projectcrates/activity.dart';
import 'package:projectcrates/helpers/reportlisting.dart';
import 'package:projectcrates/helpers/searchbar.dart';
import 'package:projectcrates/helpers/reportchat.dart';

List<int> nums = [1, 3, 2];

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[400],
          title: Text("Report",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 0,
            color: Colors.pink,
          ),
        ),
        body: ReportState());
    // body: Body());
  }
}

class ReportState extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportState> {
  final List<Tab> myTab = <Tab>[
    Tab(text: 'Listings'),
    Tab(text: 'Chats'),
    Tab(text: 'Completed')
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            shape: Border(
              top: BorderSide(color: Theme.of(context).canvasColor),
            ),
            bottom: TabBar(
              tabs: myTab,
              isScrollable: false,
              indicatorWeight: 3.0,
              //TODO OnTap Function
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
          ),
          body: TabBarView(
            children: [
              Column(children: [reportHeader(context), listofreports()]),
              Column(
                children: [
                  reportHeader(context),
                  listofreportedchats()
                  //list of stuff
                ],
              ),
              Card(child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReportListing()));
                },
              )), //
            ],
          ),
        ));
  }
}

//testing new screen

// Header for respective tabs
Widget reportHeader(BuildContext context) {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
          child: Text('Search'),
        ), //change to search later
      ),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: EdgeInsets.only(right: 10.0),
              child: TextButton.icon(
                icon: Icon(Icons.sort),
                label: Text('Sort'),
                onPressed: () {
                  nums.sort();
                },
              )))
    ],
  ));
}

class ReportListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[400],
          title: Text("Reported Listing",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 20,
            color: Colors.pink,
          ),
        ),
        body: reportListingFormat(context));
    // body: Body());
  }
}

class ReportChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[400],
          title: Text("Reported Listing",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(40.0))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 20,
            color: Colors.pink,
          ),
        ),
        body: reportChatFormat(context));
    // body: Body());
  }
}
