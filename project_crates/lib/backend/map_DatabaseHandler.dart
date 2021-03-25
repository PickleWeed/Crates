import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/Listing.dart';

class DataHandler {
  static final DataHandler _imagePresenter = DataHandler._internal();

  factory DataHandler() {
    return _imagePresenter;
  }
  // singleton boilerplate
  DataHandler._internal();

  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> getImg(String imageType,String imageName) async {
    String url = await FirebaseStorage.instance.ref().child("$imageType/$imageName").getDownloadURL();
    print("url retrieve successfully $url");
    return url;
  }
  //insert current location as argument
  Future<List<Listing>> retrieveFilteredListing(double distance, String category, LatLng center) async {
    print(center.longitude);
    print(center.latitude);
    print('retrieve Filtered Listing!');
    List<Listing> userNormalListing = new List<Listing>();
    String url = "";
    try {
      await _databaseRef.child("Listing").once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((key, value) {
          double calculatedDistance = 0;
          double long2 = value['longitude'];
          double lati2 = value['latitude'];
          print('lati2: $lati2');
          print('long2: $long2');
          calculatedDistance = haversine(
              center.latitude, center.longitude, value['latitude'],
              value['longitude']);
          print('calculated: $calculatedDistance');
          if (value['isRequest'] == true && calculatedDistance <= distance &&
              (category == value['category'] || category == '')) {
            //url = getImg("normalListings", snapshot.key).toString();
            Listing normalListing = new Listing(listingID: snapshot.key,
                listingTitle: value['listingTitle'],
                category: value['category']
                ,
                postDateTime: DateTime.parse(value['postDateTime']),
                description: value['description'],
                isRequest: value['isRequest'],
                listingImage: File(url),
                longitude: value['longitude'],
                latitude: value['latitude']);
            userNormalListing.add(normalListing);
          }
        });
      });
    } catch (e){
      print(e);
    }
    print(userNormalListing.length);
    return userNormalListing;
  }
  //TODO for testing, almost never use
  Future<List<Listing>> retrieveAllListing() async {
    print('retrieveAllListing!');
    List<Listing> userNormalListing = new List<Listing>();
    String url = "";
    try {
      await _databaseRef.child("Listing").once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((key, value) {
          //print('calculated: $calculatedDistance');
          if (value['isRequest'] == true) {
            //url = getImg("normalListings", snapshot.key).toString();
            Listing normalListing = new Listing(listingID: snapshot.key,
                listingTitle: value['listingTitle'],
                category: value['category'],
                postDateTime: DateTime.parse(value['postDateTime']),
                description: value['description'],
                isRequest: value['isRequest'],
                listingImage: File(url),
                longitude: value['longitude'],
                latitude: value['latitude']);
            userNormalListing.add(normalListing);
          }
        });
      });
    } catch(e) {
      print(e);
    }
    return userNormalListing;
  }
  //return distance
  double haversine(double lat1, double lon1, double lat2, double lon2){
    if(lat1 == null || lat2 == null || lon1 == null || lon2 == null) {
      print('List Error! Null value - GPS position: $lat1, $lon1, listing position: $lat2, $lon2.');
      return null;
    }
    else{
      final R = 6372.8; // In kilometers

      double dLat = radians(lat2 - lat1);
      double dLon = radians(lon2 - lon1);
      lat1 = radians(lat1);
      lat2 = radians(lat2);
      double a = pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
      double c = 2 * asin(sqrt(a));
      return R * c;
    }
  }
}
