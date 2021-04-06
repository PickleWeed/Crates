import 'package:firebase_database/firebase_database.dart';

class StateService {
  final dbRef = FirebaseDatabase.instance.reference();
  Future<List> getListingTiles(String query) async {
    List listingTitles = [];
    await dbRef
        .child('Listing')
        .orderByChild('listingTitle')
        .startAt(query)
        .endAt(query + "\uf8ff")
        .once()
        .then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data == null) return listingTitles;
      data.forEach((key, values) {
        listingTitles.add(values['listingTitle']);
      });
    });
    return listingTitles;
  }
}
