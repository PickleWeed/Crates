import 'package:firebase_database/firebase_database.dart';
import 'models/Listing.dart';

class DatabaseAccess {
  final databaseRef = FirebaseDatabase.instance.reference();

  //TODO integrate image storing functionality
  //add a listing to firebase database, returns the unique key identifier of the created node as a String
  String addListing(Listing newListing) {
    DatabaseReference pushedPostRef = databaseRef.child("Listing").push();
    String postKey = pushedPostRef.key;
    pushedPostRef.set({
      "isRequest": newListing.isRequest,
      "category": newListing.category,
      "itemName": newListing.itemName,
      "description": newListing.description,
      "postDateTime": DateTime.now().toIso8601String(),
      "userID": newListing.userID, //TODO change this to pass in userID
    });
    return postKey;
  }

  //find the unique key of a listing node using its field values
  Future<String> findKeyOfListing(Listing existingListing) async {
    List list = [];
    await databaseRef
        .child("Listing")
        .orderByChild("userID")
        .equalTo(existingListing.userID)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      data.forEach((key, values) {
        if (values['postDateTime'] ==
                existingListing.postDateTime.toIso8601String() &&
            values['description'] == existingListing.description &&
            values['itemName'] == existingListing.itemName &&
            values['category'] == existingListing.category &&
            values['isRequest'] == existingListing.isRequest) {
          list.add(key);
        }
      });
    });
    try {
      return list[0];
    } catch (e) {
      print("Error finding matching listings");
      return null;
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

  void deleteListingOnValue(Listing existingListing) async {
    String postKey = await findKeyOfListing(existingListing);
    deleteListingOnKey(postKey);
  }

  //update an entire listing node with a new listing, postDateTime updated to DateTime.now()
  void updateListing(String existingListingID, Listing updatedListing) {
    Map<String, dynamic> map = {
      "isRequest": updatedListing.isRequest,
      "category": updatedListing.category,
      "itemName": updatedListing.itemName,
      "description": updatedListing.description,
      "postDateTime": DateTime.now().toIso8601String(),
      "userID": updatedListing.userID, //TODO change this to pass in userID
    };

    databaseRef.child("Listing").child(existingListingID).set(map);
  }
}
