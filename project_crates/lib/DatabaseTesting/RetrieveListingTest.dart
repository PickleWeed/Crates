import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/databaseAccess.dart';

class RetrieveListingTest extends StatefulWidget {
  @override
  _RetrieveListingTestState createState() => _RetrieveListingTestState();
}

class _RetrieveListingTestState extends State<RetrieveListingTest> {
  DatabaseAccess dao = new DatabaseAccess();
  List listingList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: dao.retrieveListingStream(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            listingList.clear();
            DataSnapshot dataValues = snapshot.data.snapshot;
            Map<dynamic, dynamic> values = dataValues.value;
            values.forEach((key, value) {
              listingList.add(value);
            });
            return new ListView.builder(
              shrinkWrap: true,
              itemCount: listingList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title: " + listingList[index]["listingTitle"]),
                    Text("Description: " + listingList[index]["description"]),
                    Text("Category: " + listingList[index]["category"]),
                  ],
                ));
              },
            );
          }),
    );
  }
}
