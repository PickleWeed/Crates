import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/models/Listing.dart';

class SearchListingPresenter {
  static final SearchListingPresenter _searchListingPresenter = SearchListingPresenter
      ._internal();

  factory SearchListingPresenter() {
    return _searchListingPresenter;
  }

  // singleton boilerplate
  SearchListingPresenter._internal();

  Future<List<Listing>> getMatchingListings(String query) async {
    List<Listing> listingList = [];
    await FirebaseDatabase.instance
        .reference()
        .child('Listing')
        .orderByChild('listingTitle')
        .startAt(query)
        .endAt(query + '\uf8ff')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data == null) return listingList;
      data.forEach((key, value) {
        Listing newListing = Listing(
          listingID: key,
          category: value['category'],
          isRequest: value['isRequest'],
          listingImage: value['listingImage'],
          latitude: value['latitude'],
          listingTitle: value['listingTitle'],
          description: value['description'],
          postDateTime: DateTime.parse(value['postDateTime']),
          userID: value['userID'],
          longitude: value['longitude'],
          isComplete: value['isComplete'],
        );
        listingList.add(newListing);
      });
    });
    return listingList;
  }

}
