import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'homeListView.dart';

class ListingList extends StatelessWidget {

  List<HomeViewModel> listings;

  ListingList({this.listings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.listings.length,
      //loop
      itemBuilder: (BuildContext context, int index) {

        final listing = this.listings[index];



        //TODO Replace this, add Category listings here
        return ListTile(
          title: Text(listing.listingTitle),
        );
      },
    );
  }

}