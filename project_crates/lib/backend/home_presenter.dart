import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/Listing.dart';

class ListingData {
  final _databaseRef = FirebaseDatabase.instance.reference();

  Future<List<Listing>> getListings(category) async {
    var userNormalListing = <Listing>[];
    var noCategory = false;

    if (category == '' || category == 'All Categories') {
      noCategory = true;
    } //mean there are no category selected

    try {
      await _databaseRef
          .child('Listing')
          .orderByChild('postDateTime')
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((key, value) {
          if (value['isComplete'] == false &&
              (category == value['category'] || noCategory)) {
            var normalListing = Listing(
                listingID: key,
                userID: value['userID'],
                listingTitle: value['listingTitle'],
                category: value['category'],
                postDateTime: DateTime.parse(value['postDateTime']),
                description: value['description'],
                isRequest: value['isRequest'],
                isComplete: value['isComplete'],
                listingImage: value['listingImage'],
                longitude: value['longitude'],
                latitude: value['latitude']);
            userNormalListing.add(normalListing);
          }
        });
      });
    } catch (e) {
      print(e);
    }
    return userNormalListing;
  }

}
