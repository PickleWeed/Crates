import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:flutter_application_1/services/storageAccess.dart';

class DatabaseAccess {
  final databaseRef = FirebaseDatabase.instance.reference();
  StorageAccess storageAccess = new StorageAccess();

  //add a listing to firebase database, returns the unique key identifier of the created node as a String
  Future<String> addListing(Listing newListing) async {
    DatabaseReference pushedPostRef = databaseRef.child("Listing").push();
    String postKey = pushedPostRef.key;
    String imageString = newListing.listingImage == null
        ? null
        : await storageAccess.uploadFile(newListing.listingImage);
    pushedPostRef.set({
      "isRequest": newListing.isRequest,
      "category": newListing.category,
      "listingTitle": newListing.listingTitle,
      "description": newListing.description,
      "latitude": newListing.latitude,
      "longitude": newListing.longitude,
      "listingImage": imageString,
      "postDateTime": DateTime.now().toIso8601String(),
      "userID": newListing.userID,
    });
    print('Created postKey: $postKey');
    return postKey;
  }

  Future<Listing> getListing(String key) async {
    Listing listing;
    await databaseRef
        .child('Listing')
        .orderByKey()
        .equalTo(key)
        .once()
        .then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      Map listingData = data[key];
      File listingImageFile =
          await storageAccess.fileFromImageUrl(listingData['listingImage']);
      listing = Listing(
        category: listingData['category'],
        isRequest: listingData['isRequest'],
        listingImage: listingImageFile,
        latitude: listingData['latitude'],
        listingTitle: listingData['listingTitle'],
        description: listingData['description'],
        postDateTime: DateTime.parse(listingData['postDateTime']),
        userID: listingData['userID'],
        longitude: listingData['longitude'],
      );
    });
    return listing;
  }

  //to access an individual listing, use list[index].attributeName
  Future<List<Listing>> retrieveAllListings() async {
    List<Listing> list = [];
    DatabaseReference ref = databaseRef.child('Listing');
    await ref.once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      for (var entry in data.entries) {
        Listing listing = await getListing(entry.key);
        list.add(listing);
      }
    });
    return list;
  }

  Stream retrieveListingStream() {
    Stream stream = databaseRef.child("Listing").onValue;
    return stream;
  }

  //find the unique key of a listing node using its field values
  // Future<String> findKeyOfListing(Listing existingListing) async {
  //   List list = [];
  //   await databaseRef
  //       .child("Listing")
  //       .orderByChild("userID")
  //       .equalTo(existingListing.userID)
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     Map<dynamic, dynamic> data = snapshot.value;
  //     data.forEach((key, values) {
  //       if (values['postDateTime'] ==
  //               existingListing.postDateTime.toIso8601String() &&
  //           values['latitude'] == existingListing.latitude &&
  //           values['longitude'] == existingListing.longitude &&
  //           values['description'] == existingListing.description &&
  //           values['listingTitle'] == existingListing.listingTitle &&
  //           values['category'] == existingListing.category &&
  //           values['isRequest'] == existingListing.isRequest) {
  //         list.add(key);
  //       }
  //     });
  //   });
  //   try {
  //     return list[0];
  //   } catch (e) {
  //     print("Error finding matching listings");
  //     return null;
  //   }
  // }

  //delete listing node using its unique key
  void deleteListingOnKey(String key) async {
    DatabaseReference entryRef = databaseRef.child("Listing").child(key);
    //delete image from storage if it exists
    await entryRef.once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data['listingImage'] != null) {
        await storageAccess.deleteListingImage(data['listingImage']);
      }
    });
    //after storage deletion, delete database entry
    try {
      databaseRef.child("Listing").child(key).remove();
    } catch (e) {
      print("Deletion unsuccessful");
      print(e);
    }
  }

  // void deleteListingOnValue(Listing existingListing) async {
  //   String postKey = await findKeyOfListing(existingListing);
  //   deleteListingOnKey(postKey);
  // }

  //update an entire listing node with a new listing, postDateTime updated to DateTime.now()
  void updateListing(String existingListingID, Listing updatedListing) async {
    String imageString = updatedListing.listingImage == null
        ? null
        : await storageAccess.uploadFile(updatedListing.listingImage);
    Map<String, dynamic> map = {
      "isRequest": updatedListing.isRequest,
      "category": updatedListing.category,
      "listingTitle": updatedListing.listingTitle,
      "description": updatedListing.description,
      "latitude": updatedListing.latitude,
      "longitude": updatedListing.longitude,
      "listingImage": imageString,
      "postDateTime": DateTime.now().toIso8601String(),
      "userID": updatedListing.userID,
    };

    databaseRef.child("Listing").child(existingListingID).set(map);
  }
}
