import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Profile/models/Listing.dart';

class DataHandler {


  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> getImg(String imageType,String imageName) async {
    String url = await FirebaseStorage.instance.ref().child("$imageType/$imageName").getDownloadURL();
    print("url retrieve successfully $url");
    return url;
  }

  Future<void> retrieveUserListing(double latitude, double longitude) async {
    List<Listing> userNormalListing = new List<Listing>();
    String url = "";
    await _databaseRef.child("Listing").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        //TODO if logic
        if(value['latitude']== latitude && value['longitude'] == longitude){
          url = getImg("normalListings", snapshot.key).toString();
          Listing normalListing = new Listing(listingID: snapshot.key,listingTitle: value['listingTitle'],category: value['category']
              ,postDateTime: value['postDateTime'],description: value['description'],isRequest: value['isRequest'],
              listingImage: File(url),longitude: value['longitude'],latitude:value['latitude'] );
          userNormalListing.add(normalListing);
        }
      });
    });

    return userNormalListing;
  }
}
