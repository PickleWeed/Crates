import 'package:firebase_database/firebase_database.dart';

class StateService {
  final dbRef = FirebaseDatabase.instance.reference();
  Future<List> getListingTiles(String query) async {
    List listingTitles = [];
    await dbRef.child('Listing').once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data == null) return listingTitles;
      data.forEach((key, values) {
        if (values['listingTitle'].toLowerCase().contains(query.toLowerCase()))
          listingTitles.add(values['listingTitle']);
      });
    });
    listingTitles = listingTitles.toSet().toList();
    return listingTitles;
  }

  Future<List> getListingTilesWithCat(String query, String category) async {
    List listingTitles = [];
    await dbRef
        .child('Listing')
        .orderByChild('category')
        .equalTo(category)
        .once()
        .then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data == null) return listingTitles;
      data.forEach((key, values) {
        if (values['listingTitle'].toLowerCase().contains(query.toLowerCase()))
          listingTitles.add(values['listingTitle']);
      });
    });
    listingTitles = listingTitles.toSet().toList();
    return listingTitles;
  }
}
