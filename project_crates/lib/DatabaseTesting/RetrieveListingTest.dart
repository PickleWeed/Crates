import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Listing.dart';
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
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: dao.retrieveListingStream(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              listingList.clear();
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              values.forEach((key, value) {
                Listing listing = dbToListing(value);
                listingList.add(listing);
              });
              return new ListView.builder(
                shrinkWrap: true,
                itemCount: listingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: " + listingList[index].listingTitle),
                      Text("Description: " + listingList[index].description),
                      Text("Category: " + listingList[index].category),
                      Row(
                          children: listingList[index].listingImage.length != 0
                              ? urlToList(listingList[index].listingImage)
                              : [Container(height: 50, width: 50)]),
                    ],
                  ));
                },
              );
            }),
      ),
    );
  }

  List<Widget> urlToList(List<String> imageURLs) {
    // imageURLs.removeLast();
    List<Widget> widgetList = [];
    for (var url in imageURLs) {
      widgetList.add(Image.network(url, width: 50, height: 50));
    }
    return widgetList;
  }

  Listing dbToListing(Map databaseEntry) {
    List<String> imageURLs = databaseEntry["listingImage"] != null
        ? databaseEntry["listingImage"].split('||')
        : ['dummy'];
    imageURLs.removeLast();

    Listing listing = new Listing(
      isRequest: databaseEntry["isRequest"],
      category: databaseEntry["category"],
      listingTitle: databaseEntry["listingTitle"],
      description: databaseEntry["description"],
      // postDateTime: DateTime.parse(databaseEntry["postDateTime"]),
      userID: databaseEntry["userID"],
      latitude: databaseEntry["latitude"],
      longitude: databaseEntry["longitude"],
      listingImage: imageURLs,
    );

    return listing;
  }
}
