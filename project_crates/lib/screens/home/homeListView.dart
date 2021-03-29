import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/Listing.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'listingsData.dart';


class HomeListViewModel extends ChangeNotifier {

  List<HomeViewModel> listings;
  
  Future <void> fetchListing(category) async {
    final listings = await ListingData().getListings(category);
    this.listings = listings.map((listing) => HomeViewModel(listing: listing)).toList();
    notifyListeners();
  }

}


class HomeViewModel {

  final Listing listing;
  HomeViewModel({this.listing});

  String get listingTitle {
    return this.listing.listingTitle;
  }
  String get listingCategory {
    return this.listing.category;
  }
  String get listingDescription {
    return this.listing.description;
  }
  bool get listingIsComplete {
    return this.listingIsComplete;
  }
  bool get listingIsRequest {
    return this.listingIsRequest;
  }
}