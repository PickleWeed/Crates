import 'package:firebase_database/firebase_database.dart';

class DatabaseAccess {
  final databaseRef = FirebaseDatabase.instance.reference();

  //TODO integrate image storing functionality
  void addListing(bool isRequest, String category, String itemName,
      String description, String userID) {
    databaseRef.child("Listing").push().set({
      "isRequest": isRequest,
      "category": category,
      "itemName": itemName,
      "description": description,
      "userID": userID,
    });
  }
}
