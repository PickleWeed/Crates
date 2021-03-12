import 'package:firebase_database/firebase_database.dart';

class DatabaseAccess {
  final databaseRef = FirebaseDatabase.instance.reference();

  //TODO integrate image storing functionality
  String addListing(bool isRequest, String category, String itemName,
      String description, DateTime postDateTime, String userID) {
    DatabaseReference pushedPostRef = databaseRef.child("Listing").push();
    String postKey = pushedPostRef.key;
    pushedPostRef.set({
      "isRequest": isRequest,
      "category": category,
      "itemName": itemName,
      "description": description,
      "postDateTime": postDateTime.toIso8601String(),
      "userID": userID,
    });
    return postKey;
  }

  //find the unique key of a listing node using its field values
  Future<String> findKeyOfListing(
      bool isRequest,
      String category,
      String itemName,
      String description,
      DateTime postDateTime,
      String userID) async {
    List list = [];
    await databaseRef
        .child("Listing")
        .orderByChild("userID")
        .equalTo(userID)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      data.forEach((key, values) {
        if (values['postDateTime'] == postDateTime.toIso8601String() &&
            values['description'] == description &&
            values['itemName'] == itemName &&
            values['category'] == category &&
            values['isRequest'] == isRequest) {
          list.add(key);
        }
      });
    });
    try {
      return list[0];
    } catch (e) {
      print("Error finding matching listings");
    }
  }

  //delete listing node using its unique key
  void deleteListingOnKey(String key) {
    try {
      databaseRef.child("Listing").child(key).remove();
    } catch (e) {
      print("Deletion unsuccessful");
      print(e);
    }
  }

  void deleteListingOnValue(bool isRequest, String category, String itemName,
      String description, DateTime postDateTime, String userID) async {
    String postKey = await findKeyOfListing(
        isRequest, category, itemName, description, postDateTime, userID);
    deleteListingOnKey(postKey);
  }
}
